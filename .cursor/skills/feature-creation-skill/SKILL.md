---
name: feature-creation
description: >-
  Adds or completes a Coffee Shop feature (screen, service, navigation, or
  Supabase table) using MVVM and ServiceProvider. For a screen, reads the
  Figma frame with the Figma MCP before writing SwiftUI. Use when the user
  asks to implement, build, add, or finish a feature, screen, flow, tab, or
  remote service, or pastes a figma.com frame URL.
---

# Feature creation

Build one feature at a time. Follow `docs/architecture.md`. This file is the checklist; do not invent a second architecture.

## Read first

1. `MEMORY.md` — current feature status and decisions.
2. `docs/architecture.md` — DI, navigation, MVVM, previews.
3. `supabase/README.md` — only if the feature reads or writes Supabase.
4. The closest existing feature listed under [Reference screens](#reference-screens). Copy its shape. Do not copy a placeholder screen.
5. `AGENTS.md` section "Figma MCP integration" — only when the change has a screen. Token mapping lives there; do not duplicate it.

## Workflow

Copy this checklist and track it:

```
Feature progress:
- [ ] 1. Classify the change
- [ ] 2. Read the reference feature
- [ ] 3. Fetch the Figma frame (skip only when there is no screen)
- [ ] 4. Add model, protocol, local service, view model, view
- [ ] 5. Register the service on ServiceProvider
- [ ] 6. Wire navigation from an existing parent
- [ ] 7. Add DeveloperPreview fixtures and #Preview states
- [ ] 8. Add Supabase migration, DTO, and router only if remote data is in scope
- [ ] 9. Build
- [ ] 10. Update MEMORY.md
```

**1. Classify the change**

| Kind | Do this |
| --- | --- |
| New screen | New folder under `CoffeeShop/Core/<Feature>/` with Model, Service, ViewModel, View. |
| Fill a placeholder | Keep the existing view and view model. Add the protocol and local service. Change the view `init` to take the protocol. See [Placeholders](#placeholders). |
| New tab | Screen as above, then one `NavigationStack` in `MainTabBarView`. Add the case on `AppTab`. |
| Push or sheet | `Hashable` route on the parent view model. Parent already holds `ServiceProvider` and passes one protocol into the child. |
| Remote data | Local service first, then migration + DTO + router + `Remote*` type wired in `liveWithSupabase()`. |
| Shared UI | `CoffeeShop/Components/`. No service and no view model unless the piece already owns one. |

Stop and ask when the request needs a new tab, a schema change, or a payment field beyond `brand` and `last4`.

**2. Read the reference feature**

Open the files named in [Reference screens](#reference-screens) before writing code. Match naming, `handle*` methods, and the loading / error / content order.

**3. Fetch the Figma frame**

Do this before writing or changing a screen. Skip it only for a service, migration, or navigation change that does not alter layout.

1. The frame URL is required: `figma.com/design/<fileKey>/<name>?node-id=<a>-<b>`. If the user did not paste one, ask for it and stop. Do not guess `fileKey` or `nodeId`, and do not invent the layout.
2. Read the `figma-design-to-code` and `figma-swiftui` skills before any Figma tool call.
3. Call `create_session` on the Figma MCP (`plugin-figma-figma`) with that `fileKey`, then `get_design_context` with the returned `sessionId`.
4. Tool arguments: `fileKey` from the URL; `nodeId` is `<a>:<b>` (`-` becomes `:`). For a branch URL (`/design/<fileKey>/branch/<branchKey>/`), use `branchKey` as `fileKey`. Pass `clientLanguages: "swift"`, `clientFrameworks: "swiftui"`, and `skillNames: "figma-design-to-code,figma-swiftui"`. Leave the screenshot in the response.
5. If `get_design_context` returns no screenshot, call `get_screenshot` with the same `fileKey`, `nodeId`, and `sessionId` before editing.
6. Treat the response as a visual reference. Rebuild it with this skill's MVVM steps. Do not paste the generated code into the app.
7. If the Figma namespace is `needsAuth` or the call fails auth, ask the user to connect Figma in Cursor Settings → Tools & MCP. Do not retry in a loop. Do not look for a token in the repo.
8. Do not write to the file (`use_figma`, `generate_figma_design`) unless the user asks.

After the screen exists, call `get_screenshot` again and compare it to the implementation. Fix in-scope layout differences before finishing. Map colors, components, assets, and navigation bars as in `AGENTS.md`.

**4. Add the feature files**

```
CoffeeShop/Core/<Feature>/
  Model/<Model>.swift
  Service/<Feature>Providing.swift
  Service/<Feature>Service.swift
  ViewModel/<Feature>ViewModel.swift
  View/<Feature>View.swift
```

Split a screen into `<Feature>HeaderView`, `<Feature>BodyView`, and `<Feature>FooterView` when the layout has those sections. Child rows take values and closures. They do not take a service or a view model.

**5. Register the service**

1. `var <name>: any <Feature>Providing { get }` on `ServiceProvider`.
2. Stored property and init parameter on `AppServiceProvider`. Default is `<Feature>Service()`.
3. Pass `serviceProvider.<name>` from the parent. A screen never calls `AppServiceProvider.live`.

A view model takes the protocols it calls. It takes `ServiceProvider` only when that view builds child screens.

**6. Wire navigation**

- One next screen: local `Bool` and `navigationDestination(isPresented:)`.
- Several destinations: `Hashable` route and `navigationDestination(item:)`.
- Flow that must leave the tab stack: `.sheet`.
- Pushed screens do not create a `NavigationStack`. `LoginView` is the exception.
- Pushed screens call `.navigationTitle` and `.blackNavigationBarStyle()`.

**7. Previews and fixtures**

- New sample data goes on `DeveloperPreview` or `DeveloperPreview+<Feature>.swift`.
- IDs match the Supabase seed when a seed exists.
- Every screen has a `#Preview`. Wrap a pushed screen in `NavigationStack`.
- Pass `AppServiceProvider.live` or one of its services. Add a named preview for empty and error when those states exist.

**8. Remote data**

Skip this step when the feature is local-only.

1. Next numbered file in `supabase/migrations/`. Do not edit an applied migration.
2. Add a row to the table in `supabase/README.md`.
3. DTO in `CoffeeShop/Networking/DTO/`, router in `CoffeeShop/Networking/Routers/`.
4. `Remote<Feature>Service` conforms to the same protocol. Map DTO → model inside the service.
5. Construct it in `AppServiceProvider.liveWithSupabase()` and pass it into the existing init parameter.
6. Leave `AppServiceProvider.live` on the local service. Previews stay on `live`.

**9. Build**

Simulator builds run outside the sandbox. Pipe through `xcsift` (see `AGENTS.md`).

```bash
xcodebuild build -project CoffeeShop.xcodeproj -scheme CoffeeShop \
  -destination 'generic/platform=iOS Simulator' -derivedDataPath .derivedData 2>&1 | xcsift -f toon
```

Do not edit `project.pbxproj` by hand unless Xcode did not pick up a new file.

**10. Update `MEMORY.md`**

Feature status row, any new decision, and a known gap you closed or opened. Keep it under about 50 lines.

## Rules that do not change

- Views take `*Providing` protocols. View models are `@Observable @MainActor final class` and do not import SwiftUI.
- Never construct a service inside a view or view model.
- Never store a full card number or CVV. Payment methods persist `brand` + `last4` only.
- Never read or print `CoffeeShop/Secrets.plist`, `Config/Secrets.xcconfig`, or `.env*`.
- Colors come from `Color.Background`, `Color.Text`, `Color.Buttons`, `Color.Tag`, `Color.List`. Remote coffee images use `RemoteCoffeeImage`.
- Reuse `InlineLoadingView`, `InlineErrorView`, `IconTextField` before adding a new component.
- One logical change. Do not commit unless the user asks.

## Placeholders

These screens exist with an empty view model and no service. Fill them; do not add a second type.

| Screen | Path | Reachable from |
| --- | --- | --- |
| Edit Profile | `Core/Settings/EditProfile/` | Settings |
| Order History | `Core/OrderHistory/` | Settings |
| Delivery Addresses | `Core/Settings/DeliveryAddresses/` | Settings |
| Promos | `Core/Settings/Promos/` | Settings |
| Help Center | `Core/Settings/HelpCenter/` | Settings |
| Checkout | `Core/Checkout/` | Not wired. `OrderViewModel.handlePlaceOrder` is still a TODO |
| Add Payment Method | `Core/Settings/PaymentMethods/` | Payment Methods. Form is a placeholder; list is done |

`OrderHistoryEntry` is an empty struct. Give it an identity before using it in a list or as a navigation value.

## Reference screens

Copy the pair that matches the work. Add a row here when a new feature becomes the better example.

| Need | Copy |
| --- | --- |
| List that loads | `CoffeeCatalogView` + `CoffeeCatalogViewModel` |
| Form | `LoginView` + `LoginViewModel` |
| Two services | `FavoritesView` + `FavoritesViewModel` |
| Sectioned screen | `CoffeeDetailView` (header, body, footer) |
| Local + remote service | `PaymentMethodsProviding`, `PaymentMethodsService`, `RemotePaymentMethodsService` |
| Settings push | `SettingsView` + `SettingAction` |

<!-- Add notes about a reference that is easy to misuse.
Example: Favorites stores coffee IDs only; the coffee rows are a second fetch.
-->

## Feature notes

<!-- Add decisions that are not already in MEMORY.md or docs/architecture.md.
One short subsection per feature. Delete a note when it becomes a permanent rule in AGENTS.md.
-->

### _Template_

- **User goal:**
- **Entry point:** tab / push / sheet, and the parent view
- **Service methods:**
- **Model fields:**
- **Local fixture:** `DeveloperPreview` property name
- **Remote:** table name, or "local only"
- **Figma frame:** URL, or "no screen"
- **Out of scope:**

## Mistakes to avoid

<!-- Add a line when an implementation attempt fails for a non-obvious reason. -->

- Building a service inside the view or view model.
- Giving a leaf screen `ServiceProvider` when it only needs one protocol.
- Putting a `NavigationStack` inside a screen that is already pushed.
- Pointing a `#Preview` at `liveWithSupabase()`.
- Editing an applied SQL migration instead of adding the next number.
- Writing a screen from memory when the user has a Figma frame, or pasting the Figma MCP code into SwiftUI.
