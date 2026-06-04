-- CoffeeShop — Catalog schema (coffee_categories, coffees)
-- Run after 000_auth_profiles.sql

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

create table if not exists public.coffee_categories (
    id uuid primary key,
    name text not null,
    is_active boolean not null default false,
    is_all_filter boolean not null default false,
    sort_order integer not null default 0,
    created_at timestamptz not null default now()
);

comment on table public.coffee_categories is 'Catalog filter tabs (All Coffee, Latte, etc.)';
comment on column public.coffee_categories.is_all_filter is 'When true, client loads all coffees (e.g. All Coffee tab)';

create table if not exists public.coffees (
    id uuid primary key,
    category_id uuid not null references public.coffee_categories (id),
    name text not null,
    description text not null,
    long_description text not null,
    rating numeric(2, 1) not null check (rating >= 0 and rating <= 5),
    price numeric(10, 2) not null check (price >= 0),
    image_url text not null,
    sizes jsonb not null default '[]'::jsonb,
    created_at timestamptz not null default now()
);

comment on column public.coffees.category_id is 'FK to coffee_categories (excluding is_all_filter tabs)';

create index if not exists coffees_category_id_idx on public.coffees (category_id);

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

insert into public.coffee_categories (id, name, is_active, is_all_filter, sort_order)
values
    ('a1000001-0001-4001-8001-000000000001', 'All Coffee', true, true, 1),
    ('a1000001-0001-4001-8001-000000000002', 'Machiato', false, false, 2),
    ('a1000001-0001-4001-8001-000000000003', 'Latte', false, false, 3),
    ('a1000001-0001-4001-8001-000000000004', 'Americano', false, false, 4)
on conflict (id) do update set
    name = excluded.name,
    is_active = excluded.is_active,
    is_all_filter = excluded.is_all_filter,
    sort_order = excluded.sort_order;

insert into public.coffees (id, category_id, name, description, long_description, rating, price, image_url, sizes)
values
    (
        'b2000001-0001-4001-8001-000000000001',
        'a1000001-0001-4001-8001-000000000004',
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
        'a1000001-0001-4001-8001-000000000003',
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
        'a1000001-0001-4001-8001-000000000003',
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
        'a1000001-0001-4001-8001-000000000003',
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
        'a1000001-0001-4001-8001-000000000002',
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
    ),
    (
        'b2000001-0001-4001-8001-000000000006',
        'a1000001-0001-4001-8001-000000000004',
        'Americano Classico',
        'Espresso diluido con agua caliente',
        'A classic Americano combines a double shot of espresso with hot water, yielding a smooth, full-bodied cup around 240 ml. It preserves the espresso''s crema while offering a lighter mouthfeel than a straight shot—ideal for slow sipping.',
        4.4,
        3.20,
        'FlatWhiteImage',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000007',
        'a1000001-0001-4001-8001-000000000004',
        'Espresso Doppio',
        'Doble shot de espresso intenso',
        'Espresso Doppio is a double shot pulled into a small demitasse—about 60 ml of concentrated coffee with a rich crema layer. Bold, aromatic, and the foundation for most milk-based drinks on our menu.',
        4.7,
        2.90,
        'CaffePanna',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000008',
        'a1000001-0001-4001-8001-000000000003',
        'Caramel Latte',
        'Latte con jarabe de caramelo',
        'Steamed milk meets espresso and buttery caramel syrup in this 350 ml favorite. Sweet but balanced, with a silky microfoam finish and optional caramel drizzle for extra indulgence.',
        4.6,
        4.50,
        'MochaFusi',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000009',
        'a1000001-0001-4001-8001-000000000003',
        'Vanilla Latte',
        'Latte con esencia de vainilla',
        'A comforting blend of espresso, steamed milk, and Madagascar vanilla syrup. Served around 350 ml with a light foam cap—creamy, fragrant, and gently sweet without overpowering the coffee.',
        4.5,
        4.30,
        'FlatWhiteImage',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000010',
        'a1000001-0001-4001-8001-000000000003',
        'Café Mocha',
        'Chocolate belga con espresso',
        'Our signature Café Mocha layers dark chocolate, espresso, and steamed milk in a 300 ml cup. Topped with whipped cream and cocoa dust for a dessert-like treat that still delivers a proper coffee kick.',
        4.8,
        4.60,
        'CaffeeMocha',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000011',
        'a1000001-0001-4001-8001-000000000002',
        'Macchiato',
        'Espresso manchado con espuma de leche',
        'A true macchiato—“marked” with a spoonful of velvety milk foam atop a single espresso shot. Roughly 90 ml total, intense and quick, perfect when you want espresso with just a touch of creaminess.',
        4.7,
        3.40,
        'CaffePanna',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    ),
    (
        'b2000001-0001-4001-8001-000000000012',
        'a1000001-0001-4001-8001-000000000002',
        'Cortado',
        'Espresso con leche al vapor',
        'The Cortado balances equal parts espresso and warm steamed milk in a small glass—about 120 ml. Less foam than a cappuccino, more coffee forward than a latte, with a smooth, rounded finish.',
        4.6,
        3.70,
        'FlatWhiteImage',
        '[
            {"id": "1", "name": "S", "is_active": false},
            {"id": "2", "name": "M", "is_active": false},
            {"id": "3", "name": "L", "is_active": false}
        ]'::jsonb
    )
on conflict (id) do update set
    category_id = excluded.category_id,
    name = excluded.name,
    description = excluded.description,
    long_description = excluded.long_description,
    rating = excluded.rating,
    price = excluded.price,
    image_url = excluded.image_url,
    sizes = excluded.sizes;
