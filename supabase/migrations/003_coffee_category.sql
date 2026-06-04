-- CoffeeShop — Link coffees to coffee_categories
-- Run after 001_catalog.sql (if coffees already exist without category_id).

-- ---------------------------------------------------------------------------
-- Schema
-- ---------------------------------------------------------------------------

alter table public.coffee_categories
    add column if not exists is_all_filter boolean not null default false;

alter table public.coffees
    add column if not exists category_id uuid references public.coffee_categories (id);

create index if not exists coffees_category_id_idx on public.coffees (category_id);

-- "All Coffee" is a UI filter tab, not a real bucket for coffees.
update public.coffee_categories
set is_all_filter = true
where id = 'a1000001-0001-4001-8001-000000000001';

-- ---------------------------------------------------------------------------
-- Seed category assignments (fixed UUIDs from 001_catalog.sql)
-- ---------------------------------------------------------------------------

update public.coffees
set category_id = 'a1000001-0001-4001-8001-000000000004' -- Americano
where id = 'b2000001-0001-4001-8001-000000000001'; -- Coffee Panna

update public.coffees
set category_id = 'a1000001-0001-4001-8001-000000000003' -- Latte
where id = 'b2000001-0001-4001-8001-000000000002'; -- Flat White

update public.coffees
set category_id = 'a1000001-0001-4001-8001-000000000003' -- Latte
where id = 'b2000001-0001-4001-8001-000000000003'; -- Mocha Fusi

update public.coffees
set category_id = 'a1000001-0001-4001-8001-000000000003' -- Latte
where id = 'b2000001-0001-4001-8001-000000000004'; -- Mocha

update public.coffees
set category_id = 'a1000001-0001-4001-8001-000000000002' -- Machiato
where id = 'b2000001-0001-4001-8001-000000000005'; -- Capuchino

alter table public.coffees
    alter column category_id set not null;

comment on column public.coffees.category_id is 'FK to coffee_categories (excluding is_all_filter tabs)';
comment on column public.coffee_categories.is_all_filter is 'When true, client loads all coffees (e.g. All Coffee tab)';
