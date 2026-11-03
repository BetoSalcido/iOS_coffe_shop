# MEMORY.md

Persistent project state for agents. Read at the start of a task; update when a decision or status changes. Keep entries short and current, and delete what is no longer true.

Last reviewed: 2026-11-02

## Decisions

- DI is constructor injection through `ServiceProvider`. No SwiftUI `Environment` for services, no singletons inside features.
- `CoffeeShopApp` uses `AppServiceProvider.live`, which is backed by local services and `DeveloperPreview` data. Switch to `AppServiceProvider.liveWithSupabase()` to hit Supabase. Previews always use `live`.
- Networking is a hand-written PostgREST client (`URLSessionNetworkClient` + routers), not the Supabase Swift SDK.
- The access token refreshes after the splash screen and when the app returns to the foreground (`refreshSessionIfNeeded`). If refresh fails, Keychain is cleared and the user goes to Login.
- Favorites store coffee IDs only. The app fetches the coffee rows separately with `id=in.(...)`.
- Payment methods store `brand` + `last4` only.
- Coffee images are public HTTPS URLs loaded with Kingfisher, not asset names.
- Commits use Conventional Commits from 2026-11-02 on (see "Commits" in `AGENTS.md`). Earlier history uses plain sentences; do not rewrite it.

## Feature status

| Feature | Local service | Remote service | UI |
| --- | --- | --- | --- |
| Auth (login, sign-up, session) | `AuthService` | `RemoteAuthService` | Done. Google / Apple sign-in and forgot password are stubs. |
| Catalog | `CoffeeCatalogService` | `RemoteCoffeeCatalogService` | Done |
| Coffee detail | `CoffeeDetailsService` | `RemoteCoffeeDetailsService` | Done |
| Favorites | `FavoritesService` | `RemoteFavoritesService` | Done |
| Payment methods | `PaymentMethodsService` | `RemotePaymentMethodsService` | List done. `AddPaymentMethodView` form is a placeholder. |
| Order (cart) | `OrderService` | None | UI done. `handlePlaceOrder` is a TODO. `002_orders.sql` exists but is not wired. |
| Settings | `SettingsService` | None | Done |
| Checkout | None | None | Placeholder, not reachable from navigation |
| Edit Profile, Order History, Delivery Addresses, Promos, Help Center | None | None | Placeholder views with empty view models |

## Known gaps

- `CoffeeShopTests` and `CoffeeShopUITests` contain only Xcode templates. There are no real tests yet.
- `AppTab.notification` has no tab.
- `OrderHistoryEntry` is an empty struct.
- `OrderViewModel.handleretryLoad()` is misspelled (should be `handleRetryLoad`).
- `CoffeeShop/Models/` and `CoffeeShop/Utils/` are empty folders.
- The build currently has 2 warnings.

## Environment

- Git hooks live in `.githooks/` (versioned). Each clone must run `git config core.hooksPath .githooks` once. `commit-msg` removes the `Co-authored-by: Cursor` trailer that Cursor adds to agent commits.

- `CoffeeShop/Secrets.plist` is gitignored and holds `SUPABASE_URL` and `SUPABASE_ANON_KEY`. Without it, `APIConfig` returns empty strings and remote services fail. Never read its values; see "Secrets" in `AGENTS.md`.
- To seed payment methods, sign up in the app first, then run `010_payment_methods_seed.sql` with that email.
- For local testing, turn off "Confirm email" in Supabase Auth so sign-up logs the user in immediately.
