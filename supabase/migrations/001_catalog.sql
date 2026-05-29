-- CoffeeShop — Catalog schema (coffee_categories, coffees)
-- Run after 000_auth_profiles.sql

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

create table if not exists public.coffee_categories (
    id uuid primary key,
    name text not null,
    is_active boolean not null default false,
    sort_order integer not null default 0,
    created_at timestamptz not null default now()
);

comment on table public.coffee_categories is 'Catalog filter tabs (All Coffee, Latte, etc.)';

create table if not exists public.coffees (
    id uuid primary key,
    name text not null,
    description text not null,
    long_description text not null,
    rating numeric(2, 1) not null check (rating >= 0 and rating <= 5),
    price numeric(10, 2) not null check (price >= 0),
    image_url text not null,
    sizes jsonb not null default '[]'::jsonb,
    created_at timestamptz not null default now()
);

comment on table public.coffees is 'Coffee catalog; sizes stored as JSON array for CoffeeSizeDTO';
comment on column public.coffees.sizes is 'JSON array: [{ "id", "name", "is_active" }, ...]';

-- ---------------------------------------------------------------------------
-- Row Level Security — public read, no client writes
-- ---------------------------------------------------------------------------

alter table public.coffee_categories enable row level security;
alter table public.coffees enable row level security;

-- Anyone (anon + logged-in) can browse the menu
create policy "coffee_categories_public_read"
    on public.coffee_categories
    for select
    to anon, authenticated
    using (true);

create policy "coffees_public_read"
    on public.coffees
    for select
    to anon, authenticated
    using (true);

-- No INSERT/UPDATE/DELETE policies → client cannot modify catalog (use dashboard or service role).

-- PostgREST needs SELECT on tables for anon/authenticated roles
grant usage on schema public to anon, authenticated;
grant select on public.coffee_categories to anon, authenticated;
grant select on public.coffees to anon, authenticated;

-- ---------------------------------------------------------------------------
-- Seed data (same content as DeveloperPreview; fixed UUIDs for stable IDs)
-- ---------------------------------------------------------------------------

insert into public.coffee_categories (id, name, is_active, sort_order)
values
    ('a1000001-0001-4001-8001-000000000001', 'All Coffee', true, 1),
    ('a1000001-0001-4001-8001-000000000002', 'Machiato', false, 2),
    ('a1000001-0001-4001-8001-000000000003', 'Latte', false, 3),
    ('a1000001-0001-4001-8001-000000000004', 'Americano', false, 4)
on conflict (id) do update set
    name = excluded.name,
    is_active = excluded.is_active,
    sort_order = excluded.sort_order;

insert into public.coffees (id, name, description, long_description, rating, price, image_url, sizes)
values
    (
        'b2000001-0001-4001-8001-000000000001',
        'Coffee Panna',
        'Espresso con crema batida',
        'Coffee Panna is an espresso topped with a layer of lightly whipped cream. Typically served in a small cup of about 60–90 ml, it balances the intensity of espresso with the smooth sweetness of cream, creating a rich and velvety experience.',
        4.6,
        3.50,
        'CaffePanna',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000002',
        'Flat White',
        'Espresso con leche vaporizada',
        'A Flat White is a smooth blend of espresso and finely textured steamed milk. Usually around 160 ml (5.5 oz), it has a thin layer of microfoam and a rich espresso base, providing a creamy texture with a strong coffee flavor.',
        4.8,
        4.00,
        'FlatWhiteImage',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000003',
        'Mocha Fusi',
        'Chocolate con espresso caliente',
        'Mocha Fusi combines rich chocolate syrup with espresso and steamed milk, creating a 200 ml (7 oz) beverage that blends sweetness with a deep coffee profile. Often topped with whipped cream or cocoa powder for extra indulgence.',
        4.7,
        4.20,
        'MochaFusi',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000004',
        'Mocha',
        'Café con leche y chocolate',
        'A Mocha is a harmonious mix of espresso, steamed milk, and chocolate. Served in a cup of about 250 ml (8 oz), it offers the perfect balance between the richness of cocoa and the strength of coffee, often finished with foam or whipped cream.',
        4.5,
        3.80,
        'MochaImage',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000005',
        'Capuchino',
        'Espresso con espuma de leche',
        'A Cappuccino is an approximately 150 ml (5 oz) beverage made with 25 ml of espresso, 85 ml of steamed milk, and a thick layer of milk foam. It offers a perfect balance of bold espresso and creamy texture, often dusted with cocoa powder.',
        4.9,
        3.90,
        'CaffePanna',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    )
on conflict (id) do update set
    name = excluded.name,
    description = excluded.description,
    long_description = excluded.long_description,
    rating = excluded.rating,
    price = excluded.price,
    image_url = excluded.image_url,
    sizes = excluded.sizes;
