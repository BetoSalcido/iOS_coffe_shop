-- CoffeeShop — User favorites (coffee IDs per authenticated user)
-- Run after 001_catalog.sql (requires coffees table).

-- ---------------------------------------------------------------------------
-- Table
-- ---------------------------------------------------------------------------

create table if not exists public.user_favorites (
    user_id uuid not null references auth.users (id) on delete cascade,
    coffee_id uuid not null references public.coffees (id) on delete cascade,
    created_at timestamptz not null default now(),
    primary key (user_id, coffee_id)
);

comment on table public.user_favorites is 'Favorite coffee IDs per user; detail loaded from coffees on read';

create index if not exists user_favorites_user_id_idx on public.user_favorites (user_id);

-- ---------------------------------------------------------------------------
-- Row Level Security — owner only
-- ---------------------------------------------------------------------------

alter table public.user_favorites enable row level security;

create policy "user_favorites_select_own"
    on public.user_favorites
    for select
    to authenticated
    using (auth.uid() = user_id);

create policy "user_favorites_insert_own"
    on public.user_favorites
    for insert
    to authenticated
    with check (auth.uid() = user_id);

create policy "user_favorites_delete_own"
    on public.user_favorites
    for delete
    to authenticated
    using (auth.uid() = user_id);

grant select, insert, delete on public.user_favorites to authenticated;
