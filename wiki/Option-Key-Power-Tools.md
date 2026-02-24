# Option-Key Power Tools

Several menu items are hidden by default and only appear while the Option key is held down. This keeps the menu clean for everyday use while providing quick access to power-user features.

## How It Works

When the menu opens, the app starts a 50 ms repeating timer on the `.eventTracking` run loop mode. Each tick checks `NSEvent.modifierFlags` for the Option key. When the state changes, hidden items are toggled and the menu redraws. The timer is invalidated when the menu closes.

## Hidden Items

### Toggle Stage Manager

Enables or disables macOS Stage Manager by writing `GloballyEnabled` to `com.apple.WindowManager` preferences and restarting the Dock. The label reflects the current state:

- **Enable Stage Manager** -- when Stage Manager is off
- **Disable Stage Manager** -- when Stage Manager is on

### IP Address

The `IP: x.x.x.x` line in the network info section is marked `isHiddenWithoutOptionKey`. It only appears while Option is held, protecting your IP from shoulder surfing.

### Tor Exit Status

If the upstream API (`wtfismyip.com`) returns a `YourFuckingTorExit` value, a `Tor Exit: Yes` or `Tor Exit: No` line appears -- also hidden unless Option is held.
