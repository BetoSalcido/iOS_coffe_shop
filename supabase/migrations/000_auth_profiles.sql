-- CoffeeShop — User profiles (extends Supabase Auth)
-- Run FIRST, before catalog and orders.
--
-- Supabase already provides auth.users (email, password hash, tokens).
-- This table stores app-specific user data (name, pro status, etc.).

-- ---------------------------------------------------------------------------
-- Table
-- ---------------------------------------------------------------------------

create table if not exists public.profiles (
    id uuid primary key references auth.users (id) on delete cascade,
    email text not null,
    full_name text,
    is_pro boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

comment on table public.profiles is 'App profile per auth user; 1:1 with auth.users';

-- ---------------------------------------------------------------------------
-- Auto-create profile on sign-up
-- Pass full_name in signUp metadata: { "full_name": "John Doe" }
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
    insert into public.profiles (id, email, full_name)
    values (
        new.id,
        new.email,
        coalesce(new.raw_user_meta_data ->> 'full_name', '')
    );
    return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- updated_at trigger
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
    before update on public.profiles
    for each row
    execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

alter table public.profiles enable row level security;

create policy "profiles_select_own"
    on public.profiles
    for select
    to authenticated
    using (auth.uid() = id);

create policy "profiles_update_own"
    on public.profiles
    for update
    to authenticated
    using (auth.uid() = id)
    with check (auth.uid() = id);

-- Users cannot insert/delete profiles directly (trigger creates on sign-up)
grant select, update on public.profiles to authenticated;
