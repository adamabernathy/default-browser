# Menu Bar Interface

Browser Switch lives entirely in the macOS menu bar. There is no main window and no Dock icon.

## Status Item

The menu bar icon is an SF Symbol rendered as a template image. macOS automatically inverts it for light and dark mode. On macOS 26 (Tahoe) and later the symbol is `circle.grid.2x2.topleft.checkmark.filled`; on earlier versions it falls back to `figure.curling`.

Clicking the icon opens the main menu. The menu is rebuilt from scratch every time it opens so the browser list, VPN status, and internet info are always current.

## Menu Layout

From top to bottom:

1. **Browser list** -- every installed browser that handles both `http` and `https`. Safari and Chrome are pinned to the top; remaining browsers are sorted alphabetically. A checkmark indicates the current macOS default. Clicking a browser sets it as the default for both schemes immediately.

2. **Separator**

3. **Caffeine** -- prevents the display from sleeping. When active, the icon changes to a steaming cup with a green dot. Uses an `IOPMAssertion` of type `PreventUserIdleDisplaySleep`. The assertion is released on quit or when toggled off.

4. **Toggle Desktop Icons** -- shows or hides Finder desktop icons by writing `CreateDesktop` to `com.apple.finder` preferences and restarting Finder.

5. **Separator**

6. **Network info** -- VPN status, ISP, and location are shown as disabled (non-clickable) menu items. IP address and Tor exit status are hidden by default and revealed by holding Option. See [Network and VPN Context](Network-and-VPN-Context) and [Option-Key Power Tools](Option-Key-Power-Tools).

7. **Toggle Stage Manager** -- hidden by default, revealed by holding Option. See [Option-Key Power Tools](Option-Key-Power-Tools).

8. **Separator**

9. **Settings** -- a submenu containing Run on Startup and Scan for New Browsers. See [Settings](Settings).

10. **Separator**

11. **About** -- opens the standard macOS About panel with the app identity icon, version, build number, and copyright.

12. **Separator**

13. **Quit** (`Cmd+Q`) -- terminates the app, releasing any power assertions and cancelling network monitors.
