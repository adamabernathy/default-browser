# Browser Switch Wiki

Browser Switch is a macOS menu bar utility for changing your default web browser without opening System Settings. It sits in the menu bar, shows every browser macOS knows about, and lets you switch with one click.

This wiki covers the app's visible features, its hidden Option-key commands, how it detects browsers and network state, and how the build and release pipeline works.

## Pages

- [Installation](Installation.md) -- install from source, uninstall, and prerequisites
- [Menu Bar Interface](Menu-Bar-Interface.md) -- what you see when you click the icon
- [Option Key Power Tools](Option-Key-Power-Tools.md) -- hidden commands revealed by holding Option
- [Network and VPN Context](Network-and-VPN-Context.md) -- how the app detects VPN, ISP, location, and IP
- [Browser Discovery](Browser-Discovery.md) -- how browsers are found, deduplicated, and ordered
- [Settings](Settings.md) -- Run on Startup and Scan for New Browsers
- [Architecture](Architecture.md) -- code structure, frameworks, and build system
- [CI and Releases](CI-and-Releases.md) -- GitHub Actions, signing, and notarization
