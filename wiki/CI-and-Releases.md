# CI and Releases

All automation runs on GitHub Actions. Workflows are in `.github/workflows/`.

## CI (`ci.yml`)

Runs on every push to any branch and on pull requests.

1. **Checkout** the repo.
2. **Run tests** with `swift test`. Output is checked for warnings or errors -- if any are found, the job fails.
3. **Release build** with `swift build -c release`. Same warning/error check.

Runner: `macos-14`.

## Package (`package.yml`)

Runs on pushes to `main` and on version tags (`v*`). Also available via `workflow_dispatch`.

1. **Tests and release build** -- same checks as CI.
2. **Validate signing secrets** -- ensures all required secrets are configured before proceeding.
3. **Create .app bundle** -- assembles `dist/Browser Switch.app` with `Info.plist`, copies the release binary.
4. **Install signing certificate** -- imports the Developer ID certificate from secrets into a temporary keychain.
5. **Sign** the app bundle with `codesign --deep --options runtime`.
6. **Verify** the signature with `codesign --verify` and `spctl --assess`.
7. **Notarize** via `xcrun notarytool submit --wait` using App Store Connect API key secrets.
8. **Staple** the notarization ticket to the app.
9. **Archive** as `BrowserSwitch-macOS.zip`.
10. **Publish** -- pushes to `main` update the `current` pre-release. Version tags create a named release with auto-generated release notes.

### Required Secrets

| Secret | Purpose |
| --- | --- |
| `DEVELOPER_ID_APP_CERT_BASE64` | Base64-encoded Developer ID Application `.p12` |
| `DEVELOPER_ID_APP_CERT_PASSWORD` | Password for the `.p12` |
| `DEVELOPER_ID_APP_IDENTITY` | Signing identity string |
| `APPLE_API_KEY_ID` | App Store Connect API key ID |
| `APPLE_API_ISSUER_ID` | App Store Connect issuer ID |
| `APPLE_API_PRIVATE_KEY` | App Store Connect `.p8` private key contents |

## Version Bump (`version-bump.yml`)

Manual workflow (`workflow_dispatch`). Bumps the `VERSION` file by patch, minor, or major, commits the change, creates a git tag (`v*`), and publishes a GitHub Release. This triggers the Package workflow to build and sign a release artifact.

## Wiki Sync (`wiki.yml`)

Runs on pushes to `main` that modify files in `wiki/`. Also available via `workflow_dispatch`.

Clones the GitHub wiki repo, replaces its contents with the `wiki/` folder from the main repo, and pushes if anything changed. This keeps the wiki in sync with the codebase -- edit wiki pages as regular files in the `wiki/` directory.
