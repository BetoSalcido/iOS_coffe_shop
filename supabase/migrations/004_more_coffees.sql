-- CoffeeShop — Additional catalog coffees
-- Run after 003_coffee_category.sql (requires category_id on coffees).

insert into public.coffees (id, category_id, name, description, long_description, rating, price, image_url, sizes)
values
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
