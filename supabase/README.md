# Supabase — CoffeeShop

SQL migrations for the iOS app.

## Order of execution (important)

| # | File | Depends on | Purpose |
|---|------|------------|---------|
| 0 | `000_auth_profiles.sql` | Supabase project (auth.users exists by default) | `profiles` + trigger on sign-up |
| 1 | `001_catalog.sql` | — | Public menu (`coffee_categories`, `coffees`) |
| 2 | `002_orders.sql` | auth + catalog | User orders (FK → `auth.users`, `coffees`) |

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
| `coffee_categories` | 4 rows |
| `coffees` | 5 rows |

After a test sign-up in Auth → Users, you should see a matching row in `profiles`.

## 4. Connect iOS (recommended sequence)

1. **Auth** — `RemoteAuthService` + JWT in Keychain + sign-up with `full_name` metadata
2. **Catalog** — `APIConfig` + `liveWithSupabase()`
3. **Orders** — `OrderService` → `orders` / `order_items`

Catalog can be wired in parallel (public read, no login required). Orders **require** auth first.

## RLS summary

| Table | anon | authenticated |
|-------|------|-----------------|
| `profiles` | — | read/update own row |
| `coffee_categories` | SELECT | SELECT |
| `coffees` | SELECT | SELECT |
| `orders` | — | own rows only |
| `order_items` | — | own orders only |

## Next steps

- Step 2: `RemoteAuthService` (signUp sends `full_name` for profile trigger)
- Step 3: Catalog via `RemoteCoffeeCatalogService`
- Step 4: Orders API
