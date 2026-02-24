# Settings

The Settings submenu contains two options.

## Run on Startup

Registers or unregisters the app as a login item using `SMAppService.mainApp` (available since macOS 13, and the app targets macOS 14+).

The checkmark state reflects the current `SMAppService.Status`:

| Status | Menu state |
| --- | --- |
| `.enabled` | Checkmark (on) |
| `.requiresApproval` | Dash (mixed) |
| `.notRegistered` | No mark (off) |
| `.notFound` | No mark, item disabled |

If registration or unregistration fails, an alert is shown with the error message.

## Scan for New Browsers

Triggers a full rebuild of the menu, re-querying macOS for all installed browsers. This is useful if you just installed or removed a browser and don't want to wait for the next menu open.

Under the hood this calls `rebuildMenu(_:)`, which tears down every menu item and reconstructs them from scratch.
