# AGENTS.md - iOS Coffee Shop App

iOS app for ordering coffee and getting it delivered (e.g. Uber Eats, Didi Food). SwiftUI, MVVM, Supabase backend.

## Read first

| File | When |
| --- | --- |
| `docs/architecture.md` | Before adding or changing any screen, service, or navigation. Covers `ServiceProvider` DI, navigation, MVVM, and `DeveloperPreview`. |
| `MEMORY.md` | At the start of every task. Current state, decisions, and known gaps. |
| `supabase/README.md` | Before touching networking, DTOs, routers, or SQL. Tables, RLS, PostgREST calls, migration order. |

## Stack

- SwiftUI, Observation (`@Observable`), Swift concurrency. iOS 18.5 deployment target, Swift 5 language mode.
- One SPM dependency: Kingfisher (remote images via `RemoteCoffeeImage`).
- Supabase Auth + PostgREST over `URLSession` (`Networking/`). No Supabase SDK.
- Session tokens in Keychain (`KeychainSessionStore`).

## Layout

```
CoffeeShop/App/              CoffeeShopApp, RootView, ServiceProvider (composition root)
CoffeeShop/Core/<Feature>/   Model/ Service/ ViewModel/ View/
CoffeeShop/Components/       Shared views (InlineLoadingView, InlineErrorView, IconTextField…)
CoffeeShop/Networking/       Client, routers, DTOs, APIConfig
CoffeeShop/PreviewSupport/   DeveloperPreview fixtures
supabase/migrations/         Numbered SQL migrations (000…)
docs/                        Architecture docs
```

## Build and test

```bash
xcodebuild build -project CoffeeShop.xcodeproj -scheme CoffeeShop \
  -destination 'generic/platform=iOS Simulator' -derivedDataPath .derivedData 2>&1 | xcsift -f toon

xcodebuild test -project CoffeeShop.xcodeproj -scheme CoffeeShop \
  -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath .derivedData 2>&1 | xcsift -f toon
```

Simulator commands need to run outside the agent sandbox (CoreSimulator is blocked inside it). Build after every change to Swift files.

## Rules

- Follow `docs/architecture.md`. In short: views take `*Providing` protocols, view models are `@Observable @MainActor final class`, navigation is driven by view-model state, every screen has a `#Preview`.
- Never construct a service inside a view or view model. Add it to `ServiceProvider` / `AppServiceProvider` and inject it.
- New sample data goes in `DeveloperPreview` (or `DeveloperPreview+<Feature>.swift`). Keep IDs aligned with the Supabase seed migrations.
- Schema changes: add the next numbered file in `supabase/migrations/` and add its row to the table in `supabase/README.md`. Never edit an applied migration.
- Never commit `CoffeeShop/Secrets.plist` or `Config/Secrets.xcconfig`. Use `Secrets.plist.example` for new keys.
- Never store a full card number or CVV anywhere. Payment methods persist `brand` + `last4` only.
- Do not edit `project.pbxproj` by hand unless a new file is not picked up by Xcode.
- Commit messages follow Conventional Commits. See "Commits" below.

## Secrets — never read or reveal

Secret files in this repo: `CoffeeShop/Secrets.plist`, `Config/Secrets.xcconfig`, and any `.env*` file. `CoffeeShop/Secrets.plist.example` is safe to read.

- NEVER read, open, cat, print, echo, grep, or display the contents of a secret file.
- NEVER read or reveal access tokens, API keys, Supabase keys, Keychain values, or session tokens, including from logs, debugger output, or network responses.
- MCP servers authenticate through OAuth in Cursor (e.g. Figma). There are no stored MCP tokens in the repo; do not look for them.
- Do not run commands that would output a secret value. Check presence only as a boolean, e.g. `test -f CoffeeShop/Secrets.plist && echo present`.
- When a secret file must change, edit only non-secret lines and avoid viewing the secret lines. If a value is needed, ask the user to set it.
- To add a new secret key, add a placeholder to `Secrets.plist.example` and tell the user to fill in `Secrets.plist`.

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). When asked to generate a commit or a commit message, read `git status` and `git diff` (staged first, then unstaged) and write the message from what actually changed.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

- **type** (required): one from the table below.
- **scope** (optional): the feature folder or area in lowercase, e.g. `catalog`, `coffee-detail`, `favorites`, `order`, `checkout`, `settings`, `payment-methods`, `auth`, `networking`, `supabase`, `di`, `navigation`, `components`, `previews`.
- **subject** (required): imperative mood ("add", not "added" or "adds"), lowercase first letter, no period, 72 characters or fewer for the whole first line.
- **body** (optional): blank line after the subject. Explain what and why, not how. Wrap at 72 characters. Use it when the subject alone does not explain the change.
- **footer** (optional): `BREAKING CHANGE: <description>`, or issue references such as `Refs: #12` / `Closes: #12`.

### Types

| Type | Use for |
| --- | --- |
| `feat` | A new user-facing feature or screen |
| `fix` | A bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `style` | Formatting, whitespace, naming only; no behavior change (not UI styling, which is `feat` or `fix`) |
| `test` | Adding or fixing tests |
| `docs` | Documentation only (`docs/`, `README.md`, `AGENTS.md`, `MEMORY.md`, code comments) |
| `build` | Xcode project settings, schemes, SPM dependencies (`project.pbxproj`, `Package.resolved`) |
| `ci` | CI/CD pipelines and scripts (GitHub Actions, Xcode Cloud, fastlane) |
| `chore` | Maintenance that fits nothing else (`.gitignore`, assets cleanup, tooling config) |
| `revert` | Reverting a previous commit; body says `This reverts commit <sha>.` |

Breaking changes add `!` after the type or scope, e.g. `feat(auth)!: ...`, and need a `BREAKING CHANGE:` footer. Use them when a change forces other code or data to change too: a `*Providing` protocol, a `ServiceProvider` property, or a Supabase schema change that existing rows or clients depend on.

### Examples

```
feat(payment-methods): add card list with default selection
fix(favorites): hide add button on favorite coffee cards
refactor(networking): move Supabase headers into APIConfig
docs: document DI, navigation, MVVM, and previews
build: bump Kingfisher to 8.9.0
ci: add Xcode Cloud workflow for pull requests
chore: ignore .derivedData
```

```
feat(auth): refresh access token on launch and foreground

Supabase access tokens expire after about an hour. Refresh after the
splash screen and when the app becomes active so PostgREST calls do not
fail with 401. If the refresh fails, clear Keychain and show Login.
```

### Rules for agents

- One logical change per commit. If the diff mixes types (e.g. a feature plus a docs update), suggest splitting it, or use the type of the main change.
- A Supabase migration ships in the same commit as the code that needs it, usually `feat(supabase)` or the feature scope.
- Never stage or commit `CoffeeShop/Secrets.plist`, `Config/Secrets.xcconfig`, `.env*`, `xcuserdata/`, or `.derivedData/`.
- NEVER include `Co-authored-by: Cursor <cursoragent@cursor.com>` or any other tool attribution. Human `Co-authored-by` trailers only when the user asks.
- Cursor appends that trailer to agent commits automatically. `.githooks/commit-msg` strips it. Before committing, check `git config --get core.hooksPath` prints `.githooks`; if not, run `git config core.hooksPath .githooks`.
- After every commit, verify with `git log -1 --format=%B`. If a Cursor trailer is still there, the hook is not active: enable it and fix the message with `git commit --amend -F -`. Do not push a commit that has the trailer.
- Do not commit or push unless the user asks. When only a message is requested, return the message and stop.
- Pass multi-line messages with a heredoc so formatting is kept:

```bash
git commit -F - <<'EOF'
feat(order): place order from the cart

Send line items to the orders table and clear the cart on success.
EOF
```

## Figma MCP integration (optional)

Only needed when a task starts from a Figma design. Everything else works without it.

### Setup

- The Figma plugin is enabled for this project in `.cursor/settings.json` (`plugins.figma.enabled`). It installs the remote server `https://mcp.figma.com/mcp` plus Figma's skills.
- Each developer connects their own account once: Cursor Settings → Tools & MCP → Figma → Connect → Allow access. Auth is OAuth; there is no token to store in the repo.
- If tools fail or are missing, run "Clear All MCP Tokens" from the Command Palette, connect again, and restart Cursor.
- If the Figma namespace reports `needsAuth`, ask the user to connect. Do not retry in a loop.

### Workflow

1. The user pastes a frame URL: `figma.com/design/<fileKey>/<name>?node-id=<a>-<b>`. Use node ID `<a>:<b>`.
2. Load the `figma-design-to-code` and `figma-swiftui` skills before calling `get_design_context`.
3. Treat Figma output as a reference, not code to paste. Rebuild it in SwiftUI following `docs/architecture.md`: a View + `@Observable` ViewModel, injected `*Providing` service, state-driven navigation, and a `#Preview` using `DeveloperPreview`.
4. Use `get_screenshot` to compare the result against the frame.

### Mapping to the codebase

- Colors: use the named tokens in `Extensions/Color+Extension.swift` (`Color.Background.*`, `Color.Text.*`, `Color.Buttons.*`, `Color.Tag.*`, `Color.List.*`). For a new Figma color, add a color set in `Assets.xcassets/Colors/` and a token in that file. Use `Color(hex:)` only for one-off values that are not part of the palette.
- Components: reuse `Components/` (`InlineLoadingView`, `InlineErrorView`, `IconTextField`, `RemoteCoffeeImage`) and existing feature rows/cards before creating new ones.
- Assets: icons and images go in `Assets.xcassets/<Feature>/` with @2x and @3x. Remote coffee images stay as HTTPS URLs loaded with `RemoteCoffeeImage`, never bundled.
- Navigation bars: `.blackNavigationBarStyle()`.
- Split a screen into `<Screen>HeaderView`, `<Screen>BodyView`, `<Screen>FooterView` when the frame has clear sections, as Login, SignUp, CoffeeDetail, and PaymentMethods do.
- Do not write to the Figma file (`use_figma`, `generate_figma_design`) unless the user asks for it.

## Memory

- At the start of a task, read `MEMORY.md` for the project state and the decisions already made.
- When the task is done, update it: current state, important decisions (with why), and mistakes to avoid.
- Keep it short, about 50 lines at most. Summarize or delete anything that no longer helps.
- If something becomes a permanent rule, propose moving it into `AGENTS.md` instead of leaving it in memory.
- Never store sensitive data: keys, tokens, or personal data.
