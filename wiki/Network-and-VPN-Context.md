# Network and VPN Context

Browser Switch shows network context in the menu so you can see your connection state at a glance before choosing a browser.

## VPN Detection

VPN status is detected locally using two complementary methods, with no network requests required.

### Method 1: scutil --nc list

The app runs `/usr/sbin/scutil --nc list` and parses the output for lines containing `(Connected)` or `(Disconnected)`. If any service is connected, the status is `.connected` with the service names. If all services are disconnected (or the header is present but no services are listed), the status is `.disconnected`. If the output is unrecognizable, the status is `.unknown`.

### Method 2: netstat routing table

If `scutil` does not report a connected service, the app falls back to `/usr/sbin/netstat -rn -f inet` and looks for routes using `utun` interfaces. This catches VPN clients like OpenConnect and WireGuard that create tunnel interfaces without registering as system VPN services. Routes matching `default`, `0/1`, `128/1`, `128.0/1`, or any CIDR/dotted destination on a `utun` interface with the `U` flag are counted. Duplicate interfaces are deduplicated.

### Combined Logic

1. If `scutil` reports connected services, use that result.
2. Otherwise, if `netstat` finds `utun` routes, report connected with the interface names.
3. Otherwise, if `scutil` reported disconnected, use disconnected.
4. Otherwise, report unknown.

VPN status is refreshed every 5 seconds and on network path changes.

## Internet Info

The app fetches `https://wtfismyip.com/json` to populate:

- **IP address** -- `YourFuckingIPAddress` (hidden unless Option is held)
- **ISP** -- `YourFuckingISP`
- **Location** -- `YourFuckingLocation`, with a fallback to `YourFuckingCity, YourFuckingCountry` if the location field is missing
- **VPN** -- `YourFuckingVPN` (boolean, used internally)
- **Tor exit** -- `YourFuckingTorExit` (hidden unless Option is held)

All string fields are trimmed; empty or whitespace-only strings are treated as nil. The request has a 3-second timeout and is throttled to at most once per 60 seconds.

## Network Monitor

An `NWPathMonitor` watches for connectivity changes. When the network path updates, both the internet info and VPN status refreshes are triggered (subject to their respective throttle intervals).

## Menu Display

- **VPN: On** or **VPN: Off** with a green checkmark icon when connected
- **ISP** and **Location** as disabled text items
- **IP** and **Tor Exit** hidden unless Option is held

All info items are non-clickable (`isEnabled = false`).
