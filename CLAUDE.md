# CLAUDE.md

Browser Switch is a macOS menu bar utility for changing the default browser in one click. Pure AppKit, no SwiftUI. SPM executable targeting **macOS 14+** (Sonoma, Sequoia, Tahoe).

## Commands

```bash
swift build                            # Debug build
swift test                             # Run all tests
swift run                              # Build and launch
./scripts/build-app.sh --release --run # Standalone .app in dist/
```

No `.xcodeproj`. SPM only — Xcode can open the folder directly.

## Project Layout

| Path                                                     | Purpose                                         |
| -------------------------------------------------------- | ----------------------------------------------- |
| `Sources/BrowserSwitchMenuBarApp/main.swift`             | App delegate, menu bar UI, all primary logic    |
| `Sources/BrowserSwitchMenuBarApp/BrowserDiscovery.swift` | Browser detection, deduplication, ordering      |
| `Sources/BrowserSwitchMenuBarApp/InternetInfo.swift`     | IP/ISP/location model and JSON decoding         |
| `Sources/BrowserSwitchMenuBarApp/SystemVPNStatus.swift`  | VPN detection via `scutil` and `netstat`        |
| `Tests/BrowserSwitchMenuBarAppTests/`                    | Unit tests, one file per source type            |
| `scripts/`                                               | `build-app.sh`, `bump-version.sh`, `install.sh` |

## Architecture

The app is intentionally compact. `main.swift` owns the app delegate, menu construction, and state refresh. Supporting types are extracted only when they have clear boundaries.

- **Drawing**: All custom images use `NSImage(size:flipped:drawingHandler:)` — never `lockFocus`/`unlockFocus`. Only semantic `NSColor` (`.labelColor`, `.windowBackgroundColor`, `.systemGreen`), never hardcoded RGB. The app observes `NSApp.effectiveAppearance` via KVO to rebuild cached images on theme change.
- **Status item**: Menu bar icon is an SF Symbol with `.isTemplate = true`. macOS handles light/dark inversion. Never apply custom colors to the status item image.
- **Menu**: `rebuildMenu(_:)` reconstructs all items on each open. `.state = .on` marks the current default browser. Info items are disabled. Power tools hide unless Option is held, tracked via a 50ms poll timer on `.eventTracking` run loop mode.
- **Concurrency**: Network and shell calls run on background queues. All UI updates go through `DispatchQueue.main.async`. Requests are guarded by in-flight flags and throttled by refresh intervals.

## Apple HIG

This app must feel native — match system menu bar extras (Wi-Fi, Battery, Bluetooth). Reference: [Apple HIG](https://developer.apple.com/design/human-interface-guidelines) — [Menu bar](https://developer.apple.com/design/human-interface-guidelines/the-menu-bar) · [Menus](https://developer.apple.com/design/human-interface-guidelines/menus) · [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols) · [Dark Mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode) · [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) · [App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons) · [Alerts](https://developer.apple.com/design/human-interface-guidelines/alerts)

- **Menus**: Title-style caps. Verbs for actions. Ellipsis (`...`) before dialogs. Most-used items at top. Separators to group. `Cmd+Q` to quit. No nested submenus.
- **Icons**: SF Symbols only — no raster. Always set `accessibilityDescription`. `16x16` in menus. Monochrome default; palette only when color conveys meaning. Verify availability against macOS 14; `#available` with fallbacks for newer symbols.
- **Dark mode**: Semantic `NSColor` only. Drawing handlers so colors resolve per appearance. Respect system setting — no app toggle. **4.5:1** minimum contrast.
- **App icon**: Squircle, 512x512, `windowBackgroundColor` bg, `labelColor` symbol via palette rendering. Opaque, sRGB.
- **Alerts**: `NSAlert`, `.warning` for errors. `messageText` = problem, `informativeText` = next steps. Modal.
- **Accessibility**: Every image needs `accessibilityDescription`. Convey status by text, not color alone. Respect Reduce Motion and Increase Contrast.
- **Behavior**: `.accessory` activation policy. Silent launch. Clean termination. Standard About panel.

## Swift Style

- Pure AppKit — no SwiftUI, UIKit, or Combine.
- `struct`/`enum` over `class`. `let` over `var`. `guard let` for early exits.
- `private` by default. `internal` only for `@testable import`.
- `[weak self]` + `guard let self else { return }` in escaping closures.
- No force-unwrapping. `compactMap` to filter nils. `#available` for APIs above macOS 14.
- Factory methods prefixed `make` (e.g., `makeAppIdentityIcon()`).
- Don't over-engineer. No abstractions for one-off operations. Read files before modifying them.

## Testing

- One test file per source type in `Tests/BrowserSwitchMenuBarAppTests/`.
- `@testable import BrowserSwitchMenuBarApp`. `XCTUnwrap` over force-unwrapping.
- Naming: `test<Behavior><Scenario>` (e.g., `testDecodeReturnsNilForInvalidJSON`).
- Every new function or behavior change must have a test.
- `swift test` must pass before any task is complete.

## Git

- **Commits**: Atomic, imperative mood, under 72 chars. Body explains *why*. No secrets, `.DS_Store`, or build artifacts.
- **PRs**: `gh pr create` targeting `main`. Use `.github/pull_request_template.md`. Title under 70 chars.
- **Pre-commit gate**: `swift build` zero warnings + `swift test` passes + no unrelated changes + no APIs below macOS 14 without `#available`.

### Issues Workflow

1. **Branch** from `main` as `Issue-N` (e.g., `git checkout -b Issue-42`).
2. **Work** on that branch.
3. **Close** the issue by adding `Closes #N` at the bottom of every related commit message:

   ```
   Fix license expiration validation logic

   Closes #42
   ```

## Markdown

- ATX headings (`#`). One `# H1` per file. Blank lines around headings, code blocks, and lists.
- `-` for unordered lists. Fenced code blocks with language tags. Inline links with relative paths.
- Backticks for code, filenames, and commands. No HTML.
- When appropiate, feel free to use GFM callouts as defined below.

> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.

## GitHub Issues Workflow

When working on a GitHub issue:

1. **Create a branch** named `Issue-N` where `N` is the issue number before starting any work.

   ```sh
   git checkout -b Issue-N
   ```

2. **Work on the issue** on that branch.

3. **Tag the issue** at the bottom of every commit message related to the issue:

   ```sh
   Closes #N
   ```

   Example commit message:

   ```sh
   Fix license expiration validation logic

   Closes #42