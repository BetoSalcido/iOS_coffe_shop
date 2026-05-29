-- CoffeeShop — Orders schema (orders, order_items)
-- Run after 000_auth_profiles.sql and 001_catalog.sql

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

create table if not exists public.orders (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users (id) on delete cascade,
    status text not null default 'pending'
        check (status in ('pending', 'confirmed', 'preparing', 'delivered', 'cancelled')),
    delivery_fee numeric(10, 2) not null default 0 check (delivery_fee >= 0),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

comment on table public.orders is 'User orders; status workflow for fulfillment';

create table if not exists public.order_items (
    id uuid primary key default gen_random_uuid(),
    order_id uuid not null references public.orders (id) on delete cascade,
    coffee_id uuid references public.coffees (id) on delete set null,
    coffee_name text not null,
    size_name text not null,
    unit_price numeric(10, 2) not null check (unit_price >= 0),
    quantity integer not null check (quantity > 0),
    created_at timestamptz not null default now()
);

comment on table public.order_items is 'Line items; coffee_name/price snapshot at order time';

create index if not exists orders_user_id_idx on public.orders (user_id);
create index if not exists orders_created_at_idx on public.orders (created_at desc);
create index if not exists order_items_order_id_idx on public.order_items (order_id);

-- ---------------------------------------------------------------------------
-- updated_at trigger (shared; may already exist from 000_auth_profiles.sql)
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

drop trigger if exists orders_set_updated_at on public.orders;
create trigger orders_set_updated_at
    before update on public.orders
    for each row
    execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

alter table public.orders enable row level security;
alter table public.order_items enable row level security;

-- Orders: owner only
create policy "orders_select_own"
    on public.orders
    for select
    to authenticated
    using (auth.uid() = user_id);

create policy "orders_insert_own"
    on public.orders
    for insert
    to authenticated
    with check (auth.uid() = user_id);

create policy "orders_update_own"
    on public.orders
    for update
    to authenticated
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

-- Order items: via parent order ownership
create policy "order_items_select_own"
    on public.order_items
    for select
    to authenticated
    using (
        exists (
            select 1
            from public.orders o
            where o.id = order_items.order_id
              and o.user_id = auth.uid()
        )
    );

create policy "order_items_insert_own"
    on public.order_items
    for insert
    to authenticated
    with check (
        exists (
            select 1
            from public.orders o
            where o.id = order_items.order_id
              and o.user_id = auth.uid()
        )
    );

grant select, insert, update on public.orders to authenticated;
grant select, insert on public.order_items to authenticated;
