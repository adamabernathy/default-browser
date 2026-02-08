# Browser Switch (macOS Menu Bar App)

Browser Switch is a lightweight macOS menu bar utility that makes changing your default browser a one-click action.

If you regularly jump between Chrome, Safari, Arc, Firefox, or Edge for different tasks, Browser Switch removes the trip to System Settings and keeps your day moving along.

## Screenshot

Place a screenshot file at `docs/images/browser-switch-menu.png`, then update or keep this markdown:

![Browser Switch menu screenshot](docs/images/browser-switch-menu.png)

Recommended shot: the open menu showing browser options, current checkmark, and settings actions.

## Why It’s Useful

- Save time: switch default browser instantly from the menu bar
- Stay focused: no System Settings navigation every time
- Work your way: quickly move between work, personal, and testing browser contexts
- Built for daily use: minimal UI, fast launch, no Dock clutter in normal use

## Features

- Menu bar app with no Dock presence during normal use
- Switch default browser for `http` and `https`
- Shows installed browsers dynamically (Safari/Chrome pinned first)
- Checkmark indicates the browser currently set by macOS
- De-duplicates duplicate browser entries by display name
- About panel with app identity and copyright
- Settings menu:
  - Run on Startup
  - Scan for New Browsers
- Quit action from menu

## Requirements

- macOS 12+
- Xcode / Apple Swift toolchain

## Build and Run (Xcode)

1. Open the package in Xcode:
   - `File > Open...` and select this folder.
2. Select the `BrowserSwitchMenuBarApp` scheme.
3. Build and run.

## Build and Run (Terminal)

```bash
cd /Users/adamabernathy/dev/browserSwtich
swift build
swift run
```

## Run Tests

```bash
cd /Users/adamabernathy/dev/browserSwtich
swift test
```

## CI and Packaging

GitHub Actions workflows are included:

- `CI`: runs tests and release build on pushes/PRs
- `Package macOS App`: builds a downloadable `.app` zip artifact and publishes it on version tags (`v*`)

## License

Licensed under the MIT License. See `LICENSE`.
