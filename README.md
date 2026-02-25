# Browser Switch (macOS Menu Bar App)

[![Build](https://github.com/adamabernathy/default-browser/actions/workflows/ci.yml/badge.svg)](https://github.com/adamabernathy/default-browser/actions/workflows/ci.yml)

Browser Switch is a macOS menu bar app that changes your default browser in one click.

If you bounce between Safari, Chrome, Firefox, Arc, Edge, or a test browser during the day, Browser Switch keeps that switch in the menu bar instead of sending you into System Settings.

> [!IMPORTANT]
> Browser Switch targets macOS 14+ (Sonoma and newer).

## Current Status ✅

- Active macOS menu bar app for daily use
- Core browser switching is working (`http` and `https`)
- Built as a native AppKit app (no SwiftUI)
- CI, tests, and release packaging workflows are in the repo
- Target platform: macOS 14+

## Screenshot 📸

![Browser Switch menu screenshot](docs/images/screenshot-1.png)

## Why Use It 🚀

- Switch browsers quickly without leaving your workflow
- Keep work/personal/testing browser contexts easy to manage
- Stay in the menu bar with minimal UI and no Dock icon during normal use
- See the current default browser at a glance

## Key Features ✨

- One-click default browser switching from the menu bar
- Dynamic browser discovery (with Safari and Chrome prioritized)
- Checkmark on the browser currently selected by macOS
- Optional network and VPN context shown in the menu
- Caffeine mode to keep the display awake while you work
- Hide/show desktop icons for screen sharing and presenting
- Quick Stage Manager toggle from the menu
- Run on Startup toggle
- About panel and standard quit behavior

## Getting Started 🛠️

### Install from Source (One-Liner)

```bash
curl -fsSL https://raw.githubusercontent.com/adamabernathy/default-browser/main/scripts/install.sh | bash
```

This builds a release app and installs `Browser Switch.app` into `~/Applications`.

> [!NOTE]
> This is a menu bar app. It runs without a Dock icon during normal use, so look for the app's icon in the macOS menu bar after launch.

### Run from a Local Checkout

#### Requirements (Source Build)

- macOS 14 (Sonoma) or later
- Xcode or Xcode Command Line Tools (Swift toolchain)

#### Local Test Build

```bash
swift build
swift run
```

#### Build a Standalone `.app`

```bash
./scripts/build-app.sh --release --run
```

## Tips 💡

- Hold the `Option` key while the menu is open to reveal power tools and additional network details.
- Use Caffeine mode before demos or long screen shares to help prevent the display from sleeping.
- Hide desktop icons before presenting to reduce visual clutter and avoid exposing files on your desktop.
- Toggle Stage Manager from the same menu when you want a cleaner presenting layout.
- Keep Browser Switch in `~/Applications` if you want a per-user install with no `sudo`.
- If you enable Run on Startup, verify it in System Settings > General > Login Items.

> [!TIP]
> If you regularly present or screen share, open the menu with `Option` held to quickly access desktop icon visibility and Stage Manager controls.

### Uninstall

```bash
rm -rf ~/Applications/Browser\ Switch.app
```

## Documentation 📚

For technical details, architecture, CI, and implementation notes, use the wiki pages in `wiki/`:

- [Wiki Home](wiki/Home.md)
- [Installation](wiki/Installation.md)
- [Menu Bar Interface](wiki/Menu-Bar-Interface.md)
- [Option-Key Power Tools](wiki/Option-Key-Power-Tools.md)
- [Network and VPN Context](wiki/Network-and-VPN-Context.md)
- [Browser Discovery](wiki/Browser-Discovery.md)
- [Settings](wiki/Settings.md)
- [Architecture](wiki/Architecture.md)
- [CI and Releases](wiki/CI-and-Releases.md)

## License

Licensed under the MIT License. See `LICENSE`.
