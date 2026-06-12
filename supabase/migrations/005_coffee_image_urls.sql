-- CoffeeShop — Replace asset-name placeholders with public HTTPS image URLs
-- Run after 004_more_coffees.sql (or anytime coffees still use names like 'CaffePanna').
--
-- Required for Kingfisher (KFImage) in the iOS app.
-- URLs point to Unsplash CDN (dev/demo). Replace with Supabase Storage URLs in production:
--   https://YOUR_PROJECT_REF.supabase.co/storage/v1/object/public/coffee-images/{file}.jpg

comment on column public.coffees.image_url is 'Public HTTPS URL for remote image loading (Supabase Storage or CDN)';

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1514434753137-45f99300460e?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000001'; -- Coffee Panna

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000002'; -- Flat White

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1577727205894-9552518757d6?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000003'; -- Mocha Fusi

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000004'; -- Mocha

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000005'; -- Capuchino

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1510591509098-f4fdc866797f?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000006'; -- Americano Classico

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1485808191679-5f86510681a51?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000007'; -- Espresso Doppio

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000008'; -- Caramel Latte

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1570197788414-7784f5579574?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000009'; -- Vanilla Latte

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000010'; -- Café Mocha

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1551033403-04081d934274?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000011'; -- Macchiato

update public.coffees
set image_url = 'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=800&q=80'
where id = 'b2000001-0001-4001-8001-000000000012'; -- Cortado
