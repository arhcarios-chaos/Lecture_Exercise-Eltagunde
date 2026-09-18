-- UniServe database schema. Run this file in Supabase SQL Editor once.
create extension if not exists pgcrypto;

create type public.user_role as enum ('student', 'staff', 'admin');
create type public.request_status as enum ('pending', 'processing', 'on_hold', 'completed', 'rejected', 'cancelled');
create type public.request_priority as enum ('normal', 'high', 'urgent');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role public.user_role not null default 'student',
  service_unit text,
  created_at timestamptz not null default now()
);

create table public.service_requests (
  id uuid primary key default gen_random_uuid(),
  reference_no text unique not null default ('USR-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8))),
  student_id uuid not null references public.profiles(id),
  assigned_to uuid references public.profiles(id),
  service_type text not null,
  subject text not null check (char_length(subject) between 3 and 120),
  description text not null check (char_length(description) between 15 and 2000),
  priority public.request_priority not null default 'normal',
  status public.request_status not null default 'pending',
  attachment_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  completed_at timestamptz
);

create table public.request_updates (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null references public.service_requests(id) on delete cascade,
  status public.request_status not null,
  note text not null check (char_length(note) between 5 and 2000),
  updated_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);

create index service_requests_student_idx on public.service_requests(student_id, created_at desc);
create index service_requests_status_idx on public.service_requests(status, created_at desc);
create index request_updates_request_idx on public.request_updates(request_id, created_at asc);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)));
  return new;
end; $$;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

create or replace function public.set_request_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  if new.status = 'completed' and old.status is distinct from 'completed' then new.completed_at = now(); end if;
  return new;
end; $$;
create trigger set_request_updated before update on public.service_requests for each row execute procedure public.set_request_updated_at();

create or replace function public.is_staff_or_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles where id = auth.uid() and role in ('staff','admin'));
$$;
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

alter table public.profiles enable row level security;
alter table public.service_requests enable row level security;
alter table public.request_updates enable row level security;

create policy "profiles visible to signed-in users" on public.profiles for select to authenticated using (true);
create policy "users update own profile" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid() and role = (select role from public.profiles where id = auth.uid()));
create policy "students read their requests; staff read queue" on public.service_requests for select to authenticated using (student_id = auth.uid() or public.is_staff_or_admin());
create policy "students create their own requests" on public.service_requests for insert to authenticated with check (student_id = auth.uid() and status = 'pending' and assigned_to is null);
create policy "staff manage requests" on public.service_requests for update to authenticated using (public.is_staff_or_admin()) with check (public.is_staff_or_admin());
create policy "students read relevant updates; staff create updates" on public.request_updates for select to authenticated using (public.is_staff_or_admin() or exists(select 1 from public.service_requests r where r.id=request_id and r.student_id=auth.uid()));
create policy "staff create updates" on public.request_updates for insert to authenticated with check (public.is_staff_or_admin() and updated_by=auth.uid());

-- Private attachment bucket. Create it before using uploads.
insert into storage.buckets (id, name, public) values ('request-attachments', 'request-attachments', false) on conflict do nothing;
create policy "students upload own files" on storage.objects for insert to authenticated with check (bucket_id='request-attachments' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "request participants download files" on storage.objects for select to authenticated using (bucket_id='request-attachments' and ((storage.foldername(name))[1]=auth.uid()::text or public.is_staff_or_admin()));

-- Promote authorized university accounts after they register, for example:
-- update public.profiles set role='staff', service_unit='Registrar' where id='USER_UUID';
