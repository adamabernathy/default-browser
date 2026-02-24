# Browser Discovery

Browser Switch automatically discovers every browser installed on your Mac. No configuration or hardcoded list is needed.

## How Browsers Are Found

The app queries `NSWorkspace` for all applications registered to handle both `http://` and `https://` URLs. Only apps that handle both schemes are shown. The app's own bundle ID is excluded.

Each candidate is verified to have a resolvable `urlForApplication(withBundleIdentifier:)` -- if macOS cannot locate the app on disk, it is skipped.

## Deduplication

When multiple copies of the same browser are installed (e.g., one in `/Applications` and one in `~/Applications`), they are deduplicated by display name. The comparison is case-insensitive and trims whitespace.

When two candidates share a display name, the app keeps the one installed in the preferred location:

| Rank | Location | Example |
| --- | --- | --- |
| 0 | `/Applications/` | `/Applications/Firefox.app` |
| 1 | `~/Applications/` | `~/Applications/Firefox.app` |
| 2 | Anywhere else | `/opt/Firefox.app` |

If both candidates are in the same location tier, the one with the shorter path wins. If paths are the same length, alphabetical order breaks the tie.

Candidates with blank or whitespace-only display names fall back to their bundle ID as the deduplication key, so they are never collapsed together.

## Ordering

Safari and Chrome are pinned to the top of the list in that order (configurable via `preferredBrowserOrder` in the source). All other browsers are sorted alphabetically by display name, with bundle ID as a tiebreaker.

## Display Names

The display name shown in the menu is resolved in order:

1. `CFBundleDisplayName` from the app's `Info.plist`
2. `CFBundleName` from the app's `Info.plist`
3. The filename of the `.app` bundle without the extension

## Rescanning

The browser list is rebuilt every time the menu opens. You can also force a rescan from Settings > Scan for New Browsers, which tears down and reconstructs the entire menu.
