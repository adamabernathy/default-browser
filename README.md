# Browser Switch (macOS Menu Bar App)

Browser Switch is a lightweight macOS menu bar utility that makes changing your default browser a one-click action.

If you regularly jump between Chrome, Safari, Arc, Firefox, or Edge for different tasks, Browser Switch removes the trip to System Settings and keeps your day moving along.

## Screenshot

Place a screenshot file at `docs/images/browser-switch-menu.png`, then update or keep this markdown:

![Browser Switch menu screenshot](docs/images/screenshot-1.png)

Recommended shot: the open menu showing browser options, current checkmark, VPN/internet context rows, and settings actions.

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
- Internet context section in the menu:
  - VPN status from system network state (supports OpenConnect `utun` routes)
  - Green check icon when VPN is connected
  - ISP and location from `https://wtfismyip.com/json`
  - IP and Tor-exit values hidden unless the `Option` key is held
  - Network-change triggered refresh, throttled to at most once per minute
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

Use this for development logs/debugging. This mode is attached to your terminal session:

```bash
cd /Users/adamabernathy/dev/browserSwtich
swift build
swift run
```

## Build and Run as a macOS App (No Terminal Window)

Build a local `.app` bundle and launch it directly:

```bash
cd /Users/adamabernathy/dev/browserSwtich
./scripts/build-app.sh --run
```

This creates `dist/Browser Switch.app`. You can double-click that app in Finder without needing a terminal window.

## Run Tests

```bash
cd /Users/adamabernathy/dev/browserSwtich
swift test
```

## CI and Packaging

GitHub Actions workflows are included:

- `CI`: runs tests and release build on pushes/PRs
- `Package macOS App`: builds a downloadable `.app` zip artifact and publishes it on version tags (`v*`)

## Release Signing Setup

This project’s release workflow signs and notarizes the app before publishing.

Required GitHub repository secrets:

- `DEVELOPER_ID_APP_CERT_BASE64`
- `DEVELOPER_ID_APP_CERT_PASSWORD`
- `DEVELOPER_ID_APP_IDENTITY`
- `APPLE_API_KEY_ID`
- `APPLE_API_ISSUER_ID`
- `APPLE_API_PRIVATE_KEY`

How to get the Apple signing certificate:

1. Join Apple Developer Program (paid account).
2. Open [developer.apple.com/account](https://developer.apple.com/account) and create a `Developer ID Application` certificate.
3. Use Keychain Access `Certificate Assistant > Request a Certificate From a Certificate Authority...` to generate a CSR if needed.
4. Download and install the issued certificate into your login keychain.
5. Export the certificate as a `.p12` file from Keychain Access.

Create the certificate secrets:

```bash
# Base64-encode the p12 for GitHub secret DEVELOPER_ID_APP_CERT_BASE64
base64 -i DeveloperIDApplication.p12 | pbcopy

# Put your p12 export password in GitHub secret DEVELOPER_ID_APP_CERT_PASSWORD
```

Get the codesign identity string for `DEVELOPER_ID_APP_IDENTITY`:

```bash
security find-identity -v -p codesigning
```

Use the full identity text, for example:

```text
Developer ID Application: Adam Abernathy, LLC (TEAMID1234)
```

How to get notarization API key values:

1. Open [appstoreconnect.apple.com](https://appstoreconnect.apple.com).
2. Go to `Users and Access > Integrations > App Store Connect API`.
3. Create an API key with access to notarization.
4. Download the `.p8` key file once.
5. Set:
- `APPLE_API_KEY_ID`: Key ID from App Store Connect
- `APPLE_API_ISSUER_ID`: Issuer ID from App Store Connect
- `APPLE_API_PRIVATE_KEY`: full text contents of the `.p8` file

After adding secrets, pushes to `main` and `v*` tags can produce signed + notarized releases.

## License

Licensed under the MIT License. See `LICENSE`.
