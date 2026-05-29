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
