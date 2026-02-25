# Installation

## Prerequisites

- macOS 14 (Sonoma) or later
- Xcode, or the Xcode Command Line Tools with Swift 5.9+

If you only have the Command Line Tools (not the full Xcode app), the build will still work. The install script and build script both prefer the full Xcode toolchain at `/Applications/Xcode.app/Contents/Developer` when it exists, and fall back to whatever `xcrun` resolves.

## Install from Source

Copy and paste this into Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/adamabernathy/default-browser/main/scripts/install.sh | bash
```

This clones the repo to a temp directory, compiles a release build, assembles the `.app` bundle, copies it to `~/Applications/Browser Switch.app`, and deletes the clone automatically. The script also works from a local checkout (`./scripts/install.sh`), in which case it skips the clone and builds from the working tree.

The app installs to `~/Applications` (per-user), not `/Applications` (system-wide), so no `sudo` is needed.

## Install from GitHub Releases

Every push to `main` publishes a signed and notarized build to the `current` release on GitHub. Tagged pushes (`v*`) create versioned releases. Download `BrowserSwitch-macOS.zip` from the [Releases page](https://github.com/adamabernathy/default-browser/releases), unzip it, and drag `Browser Switch.app` to your Applications folder.

## Uninstall

```bash
rm -rf ~/Applications/Browser\ Switch.app
```

If you enabled Run on Startup, macOS should clean up the login item automatically when the app is deleted. If the ghost entry persists, open System Settings > General > Login Items and remove it manually.

## Launching

After install, open the app from `~/Applications/Browser Switch.app` or Spotlight. It appears in the menu bar as a grid icon. There is no Dock icon by default (`LSUIElement` is set to `true`).
