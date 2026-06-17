-- CoffeeShop — Coffee detail content (long descriptions + size options)
-- Run after 005_coffee_image_urls.sql (or anytime coffees still use generic S/M/L sizes).
--
-- The iOS detail screen reads the same `coffees` row via PostgREST:
--   GET /rest/v1/coffees?id=eq.{coffee_uuid}
--
-- Fields used by CoffeeDetailView / CoffeeDTO:
--   name, description, long_description, rating, price, image_url, sizes (jsonb)
--
-- `sizes` JSON shape (snake_case for PostgREST → CoffeeSizeDTO):
--   [{"id": "1", "name": "Regular", "is_active": true}, ...]
-- One size should have is_active = true as the default selection in the app.

comment on column public.coffees.long_description is 'Full detail text shown on the coffee detail screen';
comment on column public.coffees.sizes is 'JSON array of size options: id, name, is_active (CoffeeSizeDTO)';

-- 1. Coffee Panna
update public.coffees
set
    long_description = 'Coffee Panna is an espresso topped with a layer of lightly whipped cream. Typically served in a small cup of about 60–90 ml, it balances the intensity of espresso with the smooth sweetness of cream, creating a rich and velvety experience. Best enjoyed immediately while the crema is still warm and the cream holds its silky texture.',
    sizes = '[
        {"id": "1", "name": "Regular", "is_active": true},
        {"id": "2", "name": "Extra Cream", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000001';

-- 2. Flat White
update public.coffees
set
    long_description = 'A Flat White is a smooth blend of espresso and finely textured steamed milk. Usually around 160 ml (5.5 oz), it has a thin layer of microfoam and a rich espresso base, providing a creamy texture with a strong coffee flavor. Our baristas pull a double ristretto and steam milk to a glossy microfoam for a balanced, latte-art-ready cup.',
    sizes = '[
        {"id": "1", "name": "8 oz", "is_active": false},
        {"id": "2", "name": "12 oz", "is_active": true},
        {"id": "3", "name": "16 oz", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000002';

-- 3. Mocha Fusi
update public.coffees
set
    long_description = 'Mocha Fusi combines rich chocolate syrup with espresso and steamed milk, creating a 200 ml (7 oz) beverage that blends sweetness with a deep coffee profile. Often topped with whipped cream or cocoa powder for extra indulgence. Dark cocoa and single-origin espresso give it depth without overwhelming sweetness.',
    sizes = '[
        {"id": "1", "name": "Regular", "is_active": true},
        {"id": "2", "name": "Extra Chocolate", "is_active": false},
        {"id": "3", "name": "Whipped Top", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000003';

-- 4. Mocha
update public.coffees
set
    long_description = 'A Mocha is a harmonious mix of espresso, steamed milk, and chocolate. Served in a cup of about 250 ml (8 oz), it offers the perfect balance between the richness of cocoa and the strength of coffee, often finished with foam or whipped cream. Belgian-style chocolate syrup and fresh espresso make this a crowd favorite any time of day.',
    sizes = '[
        {"id": "1", "name": "8 oz", "is_active": false},
        {"id": "2", "name": "12 oz", "is_active": true},
        {"id": "3", "name": "16 oz", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000004';

-- 5. Capuchino
update public.coffees
set
    long_description = 'A Cappuccino is an approximately 150 ml (5 oz) beverage made with 25 ml of espresso, 85 ml of steamed milk, and a thick layer of milk foam. It offers a perfect balance of bold espresso and creamy texture, often dusted with cocoa powder. Choose extra foam for a lighter drink or dry for a stronger espresso-forward profile.',
    sizes = '[
        {"id": "1", "name": "Regular", "is_active": true},
        {"id": "2", "name": "Extra Foam", "is_active": false},
        {"id": "3", "name": "Dry", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000005';

-- 6. Americano Classico
update public.coffees
set
    long_description = 'A classic Americano combines a double shot of espresso with hot water, yielding a smooth, full-bodied cup around 240 ml. It preserves the espresso''s crema while offering a lighter mouthfeel than a straight shot—ideal for slow sipping. Hot water is added after the pull to keep the crema intact and the flavor clean.',
    sizes = '[
        {"id": "1", "name": "Small", "is_active": false},
        {"id": "2", "name": "Medium", "is_active": true},
        {"id": "3", "name": "Large", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000006';

-- 7. Espresso Doppio
update public.coffees
set
    long_description = 'Espresso Doppio is a double shot pulled into a small demitasse—about 60 ml of concentrated coffee with a rich crema layer. Bold, aromatic, and the foundation for most milk-based drinks on our menu. Pulled at 9 bars with a 25–30 second extraction for maximum sweetness and body.',
    sizes = '[
        {"id": "1", "name": "Single", "is_active": false},
        {"id": "2", "name": "Doppio", "is_active": true}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000007';

-- 8. Caramel Latte
update public.coffees
set
    long_description = 'Steamed milk meets espresso and buttery caramel syrup in this 350 ml favorite. Sweet but balanced, with a silky microfoam finish and optional caramel drizzle for extra indulgence. House-made caramel and two shots of espresso create a dessert-like latte that still tastes like real coffee.',
    sizes = '[
        {"id": "1", "name": "12 oz", "is_active": false},
        {"id": "2", "name": "16 oz", "is_active": true},
        {"id": "3", "name": "20 oz", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000008';

-- 9. Vanilla Latte
update public.coffees
set
    long_description = 'A comforting blend of espresso, steamed milk, and Madagascar vanilla syrup. Served around 350 ml with a light foam cap—creamy, fragrant, and gently sweet without overpowering the coffee. Natural vanilla extract and microfoam make this an easy everyday pick.',
    sizes = '[
        {"id": "1", "name": "12 oz", "is_active": false},
        {"id": "2", "name": "16 oz", "is_active": true},
        {"id": "3", "name": "20 oz", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000009';

-- 10. Café Mocha
update public.coffees
set
    long_description = 'Our signature Café Mocha layers dark chocolate, espresso, and steamed milk in a 300 ml cup. Topped with whipped cream and cocoa dust for a dessert-like treat that still delivers a proper coffee kick. Rich Belgian cocoa and fresh whipped cream set this apart from a standard mocha.',
    sizes = '[
        {"id": "1", "name": "Regular", "is_active": true},
        {"id": "2", "name": "Extra Chocolate", "is_active": false},
        {"id": "3", "name": "Whipped Cream", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000010';

-- 11. Macchiato
update public.coffees
set
    long_description = 'A true macchiato—“marked” with a spoonful of velvety milk foam atop a single espresso shot. Roughly 90 ml total, intense and quick, perfect when you want espresso with just a touch of creaminess. The foam mark is added last so the shot stays bold from the first sip.',
    sizes = '[
        {"id": "1", "name": "Regular", "is_active": true},
        {"id": "2", "name": "Double Shot", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000011';

-- 12. Cortado
update public.coffees
set
    long_description = 'The Cortado balances equal parts espresso and warm steamed milk in a small glass—about 120 ml. Less foam than a cappuccino, more coffee forward than a latte, with a smooth, rounded finish. Traditionally served in a glass to showcase the warm tone of espresso and milk combined.',
    sizes = '[
        {"id": "1", "name": "Regular", "is_active": true},
        {"id": "2", "name": "Large", "is_active": false}
    ]'::jsonb
where id = 'b2000001-0001-4001-8001-000000000012';
