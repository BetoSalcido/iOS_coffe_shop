# Supabase — CoffeeShop

SQL migrations for the iOS app.

## Order of execution (important)

| # | File | Depends on | Purpose |
|---|------|------------|---------|
| 0 | `000_auth_profiles.sql` | Supabase project (auth.users exists by default) | `profiles` + trigger on sign-up |
| 1 | `001_catalog.sql` | — | Public menu (`coffee_categories`, `coffees`) |
| 2 | `002_orders.sql` | auth + catalog | User orders (FK → `auth.users`, `coffees`) |
| 3 | `003_coffee_category.sql` | catalog | `coffees.category_id` FK + `is_all_filter` on categories |
| 4 | `004_more_coffees.sql` | catalog | 7 additional coffees (12 total) |
| 5 | `005_coffee_image_urls.sql` | catalog | Replace asset-name placeholders with HTTPS URLs (Kingfisher) |
| 6 | `006_coffee_details.sql` | catalog | Detail copy + size options for the coffee detail screen |

**Auth in Supabase:** you do **not** create `auth.users` manually. Supabase Auth creates it when the project is created. You only add **`public.profiles`** for app data (name, `is_pro`, etc.).

## 1. Create project

1. [supabase.com](https://supabase.com) → **New project**
2. Settings → API → copy **Project URL** and **anon public** key

## 2. Run migrations

SQL Editor → New query → paste each file in order → **Run**.

## 3. Verify

| Table | Expected |
|-------|----------|
| `profiles` | Empty until first sign-up; row auto-created per user |
| `coffees` | 12 rows (each with `category_id`) |
| `coffee_categories` | 4 rows (`All Coffee` has `is_all_filter = true`) |

After a test sign-up in Auth → Users, you should see a matching row in `profiles`.

## 4. Connect iOS

1. Copy `CoffeeShop/Secrets.plist.example` → `CoffeeShop/Secrets.plist` and add URL + publishable key.
2. Use `AppServiceProvider.liveWithSupabase()` in `CoffeeShopApp` (catalog + `RemoteAuthService` + Keychain).
3. In Supabase **Authentication → Providers → Email**, disable “Confirm email” for local testing if sign-up should log in immediately.

## Email confirmation links (`localhost:3000`)

If the confirmation email opens `http://localhost:3000` and fails, fix **Authentication → URL Configuration**:

| Field | Recommended value (replace with your project ref) |
|-------|---------------------------------------------------|
| **Site URL** | `https://YOUR_PROJECT_REF.supabase.co` |
| **Redirect URLs** | `https://YOUR_PROJECT_REF.supabase.co/**` |

Remove `http://localhost:3000` from Site URL and Redirect URLs unless you run a local web app.

**Note:** The account may still be confirmed even if the browser shows an error after the redirect. Try **Login** in the app with the same email/password.

For iOS-only development, disabling **Confirm email** (step 3 above) avoids this flow entirely.

## Catalog categories

Each coffee belongs to one **real** category (`category_id` FK). The **All Coffee** tab is special: `coffee_categories.is_all_filter = true` tells the app to load every coffee without filtering.

| Coffee | Category |
|--------|----------|
| Coffee Panna, Americano Classico, Espresso Doppio | Americano |
| Flat White, Mocha Fusi, Mocha, Caramel Latte, Vanilla Latte, Café Mocha | Latte |
| Capuchino, Macchiato, Cortado | Machiato |

If you already ran `001_catalog.sql` before this column existed, run **`003_coffee_category.sql`** in the SQL Editor.

## Coffee images (`image_url`)

`coffees.image_url` must be a **public HTTPS URL** for Kingfisher (`KFImage`) in the iOS app — not an asset name like `CaffePanna`.

Fresh installs: `001_catalog.sql` and `004_more_coffees.sql` already seed Unsplash CDN URLs.

**Existing database** that still has asset names: run **`005_coffee_image_urls.sql`** in the SQL Editor. It updates all 12 rows in place.

For production, upload images to **Supabase Storage** and use URLs like:

`https://YOUR_PROJECT_REF.supabase.co/storage/v1/object/public/coffee-images/{file}.jpg`

## Coffee detail

There is **no separate detail table**. The detail screen loads one row from `public.coffees` by UUID.

### PostgREST (what the iOS app calls)

```
GET {SUPABASE_URL}/rest/v1/coffees?id=eq.{coffee_uuid}
```

Example (Coffee Panna):

```
GET .../rest/v1/coffees?id=eq.b2000001-0001-4001-8001-000000000001
```

### Fields mapped to `CoffeeDTO` → `Coffee`

| DB column | iOS property | Detail screen usage |
|-----------|--------------|---------------------|
| `name` | `name` | Header title |
| `description` | `description` | Header subtitle |
| `long_description` | `longDescription` | Description section body |
| `rating` | `rating` | Header rating badge |
| `price` | `price` | Footer price |
| `image_url` | `imageURL` | Header image (Kingfisher) |
| `sizes` (jsonb) | `sizes` | Size picker chips |

### `sizes` JSON format

```json
[
  {"id": "1", "name": "Regular", "is_active": true},
  {"id": "2", "name": "Extra Foam", "is_active": false}
]
```

Set **`is_active: true`** on one size so the app pre-selects it (`CoffeeDetailViewModel`).

### Seed / update

- **Fresh install:** run `001_catalog.sql` (base rows), then **`006_coffee_details.sql`** for full detail copy and sizes.
- **Existing database** with generic `S` / `M` / `L` sizes: run **`006_coffee_details.sql`** in the SQL Editor.

## 5. Orders (next)

Run `002_orders.sql` and wire `OrderService` to PostgREST.

## RLS summary

| Table | anon | authenticated |
|-------|------|-----------------|
| `profiles` | — | read/update own row |
| `coffee_categories` | SELECT | SELECT |
| `coffees` | SELECT | SELECT |
| `orders` | — | own rows only |
| `order_items` | — | own orders only |

## Verify auth

After sign-up in the app:

- **Authentication → Users** — new user
- **Table Editor → profiles** — row with `full_name` from sign-up metadata
