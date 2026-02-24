# Architecture

## Project Structure

Browser Switch is a Swift Package Manager executable with no `.xcodeproj`. Xcode can open the folder directly.

```
Sources/BrowserSwitchMenuBarApp/
  main.swift              -- app delegate, menu bar UI, all primary logic
  BrowserDiscovery.swift  -- browser detection, deduplication, ordering
  InternetInfo.swift      -- IP/ISP/location model and JSON decoding
  SystemVPNStatus.swift   -- VPN detection via scutil and netstat

Tests/BrowserSwitchMenuBarAppTests/
  BrowserDiscoveryTests.swift
  InternetInfoTests.swift
  SystemVPNStatusTests.swift

scripts/
  build-app.sh            -- builds a standalone .app bundle in dist/
  bump-version.sh         -- increments the VERSION file
  install.sh              -- clone-build-install one-liner
```

## Frameworks

- **AppKit** -- all UI (no SwiftUI, no UIKit)
- **CoreServices** -- `LSSetDefaultHandlerForURLScheme` for setting the default browser
- **IOKit** -- `IOPMAssertionCreateWithName` for Caffeine mode
- **Network** -- `NWPathMonitor` for connectivity change detection
- **ServiceManagement** -- `SMAppService` for Run on Startup

No third-party dependencies.

## App Lifecycle

The app sets `.accessory` activation policy (no Dock icon). On launch it terminates any other running instances of itself, builds the menu, starts the network monitor, fetches initial internet info and VPN status, and begins observing appearance changes.

On quit it releases any Caffeine power assertion, cancels the network monitor, and lets the process exit.

## Dark Mode

All custom-drawn images use `NSImage(size:flipped:drawingHandler:)` so colors are resolved at draw time, not at creation time. The app never uses `lockFocus`/`unlockFocus`. Only semantic `NSColor` values are used (`.labelColor`, `.windowBackgroundColor`, `.systemGreen`).

The menu bar icon is an SF Symbol set as `.isTemplate = true`, so macOS handles light/dark inversion automatically.

The app identity icon (shown in the About panel) uses `NSImage.SymbolConfiguration(paletteColors: [.labelColor])` so it adapts to the current appearance. A KVO observation on `NSApp.effectiveAppearance` rebuilds the cached icon whenever the theme changes.

## Menu Construction

`rebuildMenu(_:)` tears down and reconstructs all menu items on every `menuWillOpen`. This avoids stale state and keeps the code simple. Browser icons are fetched from `NSWorkspace.shared.icon(forFile:)` at 16x16. The current default browser gets `.state = .on` (checkmark). Info items are disabled (`isEnabled = false`).

## Concurrency Model

- Network requests (`URLSession.dataTask`) and system commands (`Process`) run on background queues.
- All UI updates dispatch back to `DispatchQueue.main.async`.
- Requests are guarded by in-flight boolean flags to prevent duplicate work.
- Internet info is throttled to one request per 60 seconds. VPN status is throttled to every 5 seconds.
