# Architecture

Coffee Shop is a SwiftUI app organized as **MVVM** with constructor injection. `AppServiceProvider` is the composition root. Screens never create services, and view models never import SwiftUI.

```
CoffeeShop/
  App/                  CoffeeShopApp, RootView, ServiceProvider
  Core/<Feature>/       Model, Service, ViewModel, View
  Components/           Shared views (loading, error, fields)
  Networking/           HTTP client, routers, DTOs
  PreviewSupport/       DeveloperPreview fixtures
  Extensions/
```

Each feature lives under `Core/<Feature>/`:

```
Core/OrderHistory/
  Model/
  Service/              OrderHistoryProviding.swift + OrderHistoryService.swift
  ViewModel/            OrderHistoryViewModel.swift
  View/                 OrderHistoryView.swift
```

## Dependency injection

`ServiceProvider` is the only place that knows which concrete service is live. Views and view models depend on a narrow `*Providing` protocol.

```9:17:CoffeeShop/App/ServiceProvider.swift
protocol ServiceProvider: AnyObject {
    var catalog: any CoffeeCatalogProviding { get }
    var coffeeDetails: any CoffeeDetailsProviding { get }
    var favorites: any FavoritesProviding { get }
    var order: any OrderProviding { get }
    var settings: any SettingsProviding { get }
    var auth: any AuthProviding { get }
    var paymentMethods: any PaymentMethodsProviding { get }
}
```

`CoffeeShopApp` builds one provider and passes it into `RootView`. The default `AppServiceProvider.live` uses local services. Those local services read `DeveloperPreview()`, so previews and the running app share the same sample data. `AppServiceProvider.liveWithSupabase()` swaps in the remote implementations without changing any view.

Injection has two levels:

1. **Tab roots and coordinators** take `any ServiceProvider`. They need it to build child screens (`CoffeeCatalogView`, `FavoritesView`, `SettingsView`, `MainTabBarView`).
2. **A screen and its view model** take only the protocol they call. `OrderView` takes `any OrderProviding`. `CoffeeDetailView` takes `CoffeeDetailsProviding`, `FavoritesProviding`, and `OrderProviding`. `LoginView` takes `any AuthProviding`.

The view stores the dependency and creates the view model once, inside `init`, as `@State`. The view model keeps the service `private`.

```swift
struct OrderView: View {
    @State private var viewModel: OrderViewModel

    init(service: any OrderProviding) {
        _viewModel = State(wrappedValue: OrderViewModel(service: service))
    }
}
```

```swift
@Observable @MainActor
final class OrderViewModel {
    private let service: any OrderProviding

    init(service: any OrderProviding) {
        self.service = service
        Task { await loadOrder() }
    }
}
```

Do this for a new dependency:

1. Add `SomeProviding` next to the feature. The protocol is the type views and view models see.
2. Add a local `SomeService` that conforms to it. Back it with `DeveloperPreview()` until a remote client exists.
3. Add `var some: any SomeProviding { get }` to `ServiceProvider`.
4. Give `AppServiceProvider` a stored property and an init parameter with `SomeService()` as the default. Wire the remote type inside `liveWithSupabase()` when it exists.
5. Pass `serviceProvider.some` from the parent. Do not reach for `AppServiceProvider.live` from a screen.

```swift
protocol RewardsProviding: AnyObject {
    func fetchRewards() async throws -> [Reward]
}

final class RewardsService: RewardsProviding {
    func fetchRewards() async throws -> [Reward] {
        DeveloperPreview().rewards
    }
}
```

```swift
// ServiceProvider
var rewards: any RewardsProviding { get }

// AppServiceProvider
init(
    // ...existing parameters...
    rewards: any RewardsProviding = RewardsService()
) {
    self.rewards = rewards
}
```

```swift
// Parent that already holds the provider
RewardsView(service: serviceProvider.rewards)
```

A view model that needs two services takes both protocols, the same way `FavoritesViewModel` takes `FavoritesProviding` and `CoffeeCatalogProviding`. It does not take `ServiceProvider`. Keep `ServiceProvider` on the view only when that view builds child screens.

## Navigation

Navigation is state-driven. A user action sets a value on the view model (or a local `Bool` for a one-step push). The view renders the destination from that value. Screens do not call `NavigationLink` for feature flow.

### Root flow

`RootView` owns an `AppScreen` (`splash`, `login`, `main`) and swaps the root with a fade. This is not a navigation stack.

```
CoffeeShopApp
└─ RootView
   ├─ splash → SplashView
   ├─ login  → LoginView
   │            └─ push SignUpView
   └─ main   → MainTabBarView
```

After three seconds, `RootView` asks `auth` whether a session exists and whether it can be refreshed. A valid session goes to `.main`. Anything else goes to `.login`.

`LoginView` is used in two places, and the callback decides which one it is:

- From `RootView`, `onSignInSuccess` is set. Success replaces the root with `.main`. There is no Close button.
- From Settings, it is a sheet and `onSignInSuccess` is `nil`. Success calls `dismiss()`.

`SignUpView` receives the same callback when it is pushed from the root login. From any other presenter it dismisses itself.

### Tabs

`MainTabBarView` is a `TabView` bound to `AppTab`. Each tab has its own stack, so pushing on Home does not affect Settings.

| Tab | Root | Stack owner |
| --- | --- | --- |
| Home | `CoffeeCatalogView` | The catalog view creates the `NavigationStack` |
| Favorites | `FavoritesView` | The favorites view creates the `NavigationStack` |
| Order | `OrderView` | `MainTabBarView` wraps it |
| Settings | `SettingsView` | `MainTabBarView` wraps it |

`AppTab.notification` is unused. `CheckoutView` is not reachable from any tab.

### Pushes and sheets

| From | Trigger | Destination |
| --- | --- | --- |
| Catalog, Favorites | `viewModel.selectedCoffee` (`navigationDestination(item:)`) | `CoffeeDetailView` |
| Coffee detail | `showOrder` (`navigationDestination(isPresented:)`) | `OrderView` |
| Login | `showSignUp` | `SignUpView` |
| Settings | `viewModel.selectedRoute: SettingAction` | Edit Profile, Payment Methods, Order History, Delivery Addresses, Promos, Help Center |
| Settings | `viewModel.showLoginSheet` | `LoginView` sheet |
| Payment Methods | `showPaymentMethodForm` | `PaymentMethodFormView` |

`SettingAction.login` is not pushed. `handleSettingSelection` opens the sheet instead. Logout stays on Settings and reloads the list.

Pushed screens (`CoffeeDetailView`, `SignUpView`, `OrderView`, settings children) do not create a `NavigationStack`. The stack already exists above them. `LoginView` is the exception: it is sometimes the root and sometimes a sheet, so it owns its stack.

A new tab wraps the screen once in `MainTabBarView`:

```swift
NavigationStack {
    RewardsView(service: serviceProvider.rewards)
}
.tabItem { tabIcon("RewardsIcon", tab: .rewards) }
.tag(AppTab.rewards)
```

A new push destination is a `Hashable` route on the view model. The view only maps that route to a screen.

```swift
enum OrderRoute: Hashable {
    case checkout
    case history
}

// View model
var route: OrderRoute?

func handlePlaceOrder() {
    route = .checkout
}

// View
.navigationDestination(item: $viewModel.route) { route in
    switch route {
    case .checkout:
        CheckoutView(service: orderService)
    case .history:
        OrderHistoryView(service: historyService)
    }
}
```

Use a local `Bool` plus `navigationDestination(isPresented:)` only for a single next screen, as `CoffeeDetailView` does for the order. Use `.sheet` for a flow that should not sit on the tab stack, as Settings does for login.

Pushed screens call `.navigationTitle` and `.blackNavigationBarStyle()`. Previews of those screens wrap them in `NavigationStack` so the bar is visible.

## MVVM

| Layer | Owns | Does not own |
| --- | --- | --- |
| Model | Value types (`Coffee`, `Order`, `SettingAction`) | I/O, UI |
| View | Layout, loading / error / content, bindings | Service calls, navigation decisions |
| ViewModel | Screen state, `handle*` actions, calls into `*Providing` | SwiftUI views |
| Service | Fetching and saving behind a protocol | View state |

A view model is an `@Observable @MainActor final class`. Published state is `internal` or `private(set)`. The service is `private`. User events are methods named `handle*`. Async work starts in `init` with `Task`, or from a `handle*` method.

The view reads that state in one order: loading, error with retry, then content. It forwards taps to the view model. When a destination binding needs a `Binding`, the body takes `@Bindable var viewModel = viewModel`.

`CoffeeCatalogView` and `CoffeeCatalogViewModel` are the reference pair. `LoginView` / `LoginViewModel` is the reference for a form. `FavoritesView` / `FavoritesViewModel` is the reference for a screen that needs two services.

Placeholder screens (`EditProfileView`, `OrderHistoryView`, `DeliveryAddressesView`, `PromosView`, `HelpCenterView`, `CheckoutView`) already have an empty view model. Fill them with the pattern below instead of putting logic in the view.

### New screen

`OrderHistory` is the shape to copy. `OrderHistoryEntry` is an empty model today; give it an identity before using it in a list or as a navigation value. Files:

```
Core/OrderHistory/Model/OrderHistoryEntry.swift
Core/OrderHistory/Service/OrderHistoryProviding.swift
Core/OrderHistory/Service/OrderHistoryService.swift
Core/OrderHistory/ViewModel/OrderHistoryViewModel.swift
Core/OrderHistory/View/OrderHistoryView.swift
```

Model:

```swift
struct OrderHistoryEntry: Identifiable, Hashable {
    let id: String
    let title: String
    let total: Decimal
}
```

Service:

```swift
protocol OrderHistoryProviding: AnyObject {
    func fetchHistory() async throws -> [OrderHistoryEntry]
}

final class OrderHistoryService: OrderHistoryProviding {
    func fetchHistory() async throws -> [OrderHistoryEntry] {
        DeveloperPreview().orderHistory
    }
}
```

Register `orderHistory` on `ServiceProvider` and `AppServiceProvider`, defaulting to `OrderHistoryService()`. `SettingsView` already pushes this screen; change the call to `OrderHistoryView(service: serviceProvider.orderHistory)`.

View model:

```swift
@Observable @MainActor
final class OrderHistoryViewModel {
    private(set) var entries: [OrderHistoryEntry] = []
    private(set) var isLoading = true
    private(set) var loadError: String?
    var selectedEntry: OrderHistoryEntry?

    private let service: any OrderHistoryProviding

    init(service: any OrderHistoryProviding) {
        self.service = service
        Task { await load() }
    }

    func handleRetryLoad() {
        loadError = nil
        isLoading = true
        Task { await load() }
    }

    func handleSelect(_ entry: OrderHistoryEntry) {
        selectedEntry = entry
    }

    private func load() async {
        do {
            entries = try await service.fetchHistory()
            isLoading = false
            loadError = nil
        } catch {
            entries = []
            isLoading = false
            loadError = error.localizedDescription
        }
    }
}
```

View:

```swift
struct OrderHistoryView: View {
    @State private var viewModel: OrderHistoryViewModel

    init(service: any OrderHistoryProviding) {
        _viewModel = State(wrappedValue: OrderHistoryViewModel(service: service))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        Group {
            if viewModel.isLoading && viewModel.entries.isEmpty {
                InlineLoadingView(message: "Loading orders…")
            } else if let error = viewModel.loadError {
                InlineErrorView(
                    title: "Couldn't load orders",
                    message: error,
                    onRetry: { viewModel.handleRetryLoad() }
                )
            } else if viewModel.entries.isEmpty {
                ContentUnavailableView("No orders yet", systemImage: "clock")
            } else {
                List(viewModel.entries) { entry in
                    Button(entry.title) { viewModel.handleSelect(entry) }
                }
            }
        }
        .navigationTitle("Order History")
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
        .navigationDestination(item: $viewModel.selectedEntry) { entry in
            Text(entry.title)
        }
    }
}
```

Child views such as `OrderItemRowView` stay dumb. They receive values and closures. They do not take a service or a view model unless they are a section that already does, such as `LoginBodyView`.

## Previews and `DeveloperPreview`

`DeveloperPreview` (`CoffeeShop/PreviewSupport/`) is the fixture store. Local services (`CoffeeCatalogService`, `OrderService`, `CoffeeDetailsService`, `PaymentMethodsService`) return its data, and `#Preview` blocks read it directly for layout.

Add new fixtures on `DeveloperPreview`, or in a `DeveloperPreview+<Feature>.swift` extension when the type is feature-specific (`DeveloperPreview+PaymentMethods.swift`). Do not build sample models inside the view.

Every screen view has a `#Preview`. Rules:

- A pushed screen is wrapped in `NavigationStack` so the bar and title render.
- Pass `AppServiceProvider.live` or one of its services. `live` is the local provider, so the preview does not hit the network.
- A leaf view takes models from `DeveloperPreview()`, not a service. `CoffeeCardView`, `CatalogGridView`, and `OrderItemRowView` do this.
- Add a named preview for each meaningful state (empty, error, filled). `PaymentMethodsView` has the screen, `"Sample cards"`, and `"Empty state"`. `LoginView` has `"Root flow"` and `"Sheet"`.

```swift
#Preview {
    NavigationStack {
        OrderHistoryView(service: AppServiceProvider.live.orderHistory)
    }
}

#Preview("Filled") {
    List(DeveloperPreview().orderHistory) { entry in
        Text(entry.title)
    }
}
```

| Screen | Preview |
| --- | --- |
| `SplashView` | Static layout |
| `RootView` | `AppServiceProvider.live` |
| `LoginView` | `"Root flow"` with a success callback, and `"Sheet"` |
| `SignUpView` | `NavigationStack` + `live.auth` |
| `MainTabBarView` | `live` |
| `CoffeeCatalogView` | `live` |
| `CoffeeDetailView` | `NavigationStack`, `DeveloperPreview().coffees[1]`, live detail / favorites / order services |
| `FavoritesView` | `live` |
| `OrderView` | `NavigationStack` + `live.order` |
| `SettingsView` | `NavigationStack` + `live` |
| `EditProfileView` | `NavigationStack` |
| `PaymentMethodsView` | `live.paymentMethods`, plus sample cards and empty state from `DeveloperPreview().paymentMethods` |
| `PaymentMethodFormView` | `live.paymentMethods`, plus `"Filled form data"` from `DeveloperPreview().filledPaymentMethodForm` |
| `OrderHistoryView` | `NavigationStack` |
| `DeliveryAddressesView` | `NavigationStack` |
| `PromosView` | `NavigationStack` |
| `HelpCenterView` | `NavigationStack` |
| `CheckoutView` | Bare view. Not wired into navigation yet |

Shared pieces (`InlineLoadingView`, `InlineErrorView`, `IconTextField`, `RemoteCoffeeImage`, catalog cards, order rows, settings rows) have their own previews and should keep them when their layout changes.
