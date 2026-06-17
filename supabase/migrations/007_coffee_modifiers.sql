-- CoffeeShop — Coffee modifiers + consistent size labels per drink type
-- Run after 006_coffee_details.sql
--
-- sizes   → volume/capacity only (8 oz, Small, Single, etc.) — one is_active = true
-- modifiers → extras/customizations (multi-select in the app; all is_active = false by default)
--
-- JSON shape (snake_case for PostgREST):
--   {"id": "1", "name": "12 oz", "is_active": true}
--   {"id": "m1", "name": "Sugar", "is_active": false}

alter table public.coffees
    add column if not exists modifiers jsonb not null default '[]'::jsonb;

comment on column public.coffees.sizes is 'Volume options: id, name, is_active (single-select in app)';
comment on column public.coffees.modifiers is 'Customization options: id, name, is_active (multi-select in app)';

-- 1. Coffee Panna — compact cup
update public.coffees set
    sizes = '[
        {"id": "1", "name": "Small", "is_active": true},
        {"id": "2", "name": "Medium", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra cream", "is_active": false},
        {"id": "m2", "name": "Sugar", "is_active": false},
        {"id": "m3", "name": "Double shot", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000001';

-- 2. Flat White — latte volumes
update public.coffees set
    sizes = '[
        {"id": "1", "name": "8 oz", "is_active": false},
        {"id": "2", "name": "12 oz", "is_active": true},
        {"id": "3", "name": "16 oz", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Light milk", "is_active": false},
        {"id": "m2", "name": "Extra shot", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000002';

-- 3. Mocha Fusi
update public.coffees set
    sizes = '[
        {"id": "1", "name": "8 oz", "is_active": false},
        {"id": "2", "name": "12 oz", "is_active": true},
        {"id": "3", "name": "16 oz", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra chocolate", "is_active": false},
        {"id": "m2", "name": "Whipped cream", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000003';

-- 4. Mocha
update public.coffees set
    sizes = '[
        {"id": "1", "name": "8 oz", "is_active": false},
        {"id": "2", "name": "12 oz", "is_active": true},
        {"id": "3", "name": "16 oz", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra chocolate", "is_active": false},
        {"id": "m2", "name": "Light milk", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000004';

-- 5. Capuchino
update public.coffees set
    sizes = '[
        {"id": "1", "name": "Small", "is_active": false},
        {"id": "2", "name": "Medium", "is_active": true},
        {"id": "3", "name": "Large", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra foam", "is_active": false},
        {"id": "m2", "name": "Cocoa powder", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000005';

-- 6. Americano Classico
update public.coffees set
    sizes = '[
        {"id": "1", "name": "Small", "is_active": false},
        {"id": "2", "name": "Medium", "is_active": true},
        {"id": "3", "name": "Large", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra shot", "is_active": false},
        {"id": "m2", "name": "Sugar", "is_active": false},
        {"id": "m3", "name": "Light water", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000006';

-- 7. Espresso Doppio — shot count as size
update public.coffees set
    sizes = '[
        {"id": "1", "name": "Single", "is_active": false},
        {"id": "2", "name": "Double", "is_active": true}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Sugar", "is_active": false},
        {"id": "m2", "name": "Decaf", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000007';

-- 8. Caramel Latte — large latte volumes
update public.coffees set
    sizes = '[
        {"id": "1", "name": "12 oz", "is_active": false},
        {"id": "2", "name": "16 oz", "is_active": true},
        {"id": "3", "name": "20 oz", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra caramel", "is_active": false},
        {"id": "m2", "name": "Light milk", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000008';

-- 9. Vanilla Latte
update public.coffees set
    sizes = '[
        {"id": "1", "name": "12 oz", "is_active": false},
        {"id": "2", "name": "16 oz", "is_active": true},
        {"id": "3", "name": "20 oz", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra vanilla", "is_active": false},
        {"id": "m2", "name": "Light milk", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000009';

-- 10. Café Mocha
update public.coffees set
    sizes = '[
        {"id": "1", "name": "8 oz", "is_active": false},
        {"id": "2", "name": "12 oz", "is_active": true},
        {"id": "3", "name": "16 oz", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Extra chocolate", "is_active": false},
        {"id": "m2", "name": "Whipped cream", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000010';

-- 11. Macchiato
update public.coffees set
    sizes = '[
        {"id": "1", "name": "Small", "is_active": true},
        {"id": "2", "name": "Medium", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Double shot", "is_active": false},
        {"id": "m2", "name": "Light milk", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000011';

-- 12. Cortado
update public.coffees set
    sizes = '[
        {"id": "1", "name": "Small", "is_active": true},
        {"id": "2", "name": "Medium", "is_active": false}
    ]'::jsonb,
    modifiers = '[
        {"id": "m1", "name": "Light milk", "is_active": false},
        {"id": "m2", "name": "Extra shot", "is_active": false},
        {"id": "m3", "name": "Sugar", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000012';
