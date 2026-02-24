# CLAUDE.md

## Project Overview

This is a macOS application built in Xcode using Swift and SwiftUI.

## Build and Run

```bash
# Build from command line
xcodebuild -project ProjectName.xcodeproj -scheme ProjectName -configuration Debug build

# Run tests
xcodebuild -project ProjectName.xcodeproj -scheme ProjectName test

# Clean build folder
xcodebuild -project ProjectName.xcodeproj -scheme ProjectName clean
```

If the project uses a workspace (CocoaPods, SPM with local packages):
```bash
xcodebuild -workspace ProjectName.xcworkspace -scheme ProjectName -configuration Debug build
```

## Project Structure

```
ProjectName/
├── App/                    # App entry point, AppDelegate or @main
├── Views/                  # SwiftUI views
├── ViewModels/             # ObservableObject view models
├── Models/                 # Data models and entities
├── Services/               # Networking, persistence, system APIs
├── Extensions/             # Swift type extensions
├── Resources/              # Assets, plists, entitlements
└── Tests/                  # Unit and UI tests
```

## Code Conventions

- Swift, SwiftUI-first. AppKit only when SwiftUI lacks capability.
- MVVM architecture. Views should not contain business logic.
- Use `@Observable` (macOS 14+) or `ObservableObject` depending on deployment target.
- Prefer value types (structs, enums) over classes unless reference semantics are needed.
- No force unwrapping in production code. Guard-let or if-let only.
- Error handling uses typed errors conforming to `LocalizedError` where user-facing.

## Platform Constraints

- Deployment target: macOS [VERSION]. Do not use APIs unavailable at this target.
- Check SF Symbols availability against the deployment target. Not all symbols exist on all OS versions. Use `if #available()` or fallback symbols when needed.
- Sandbox entitlements are enabled. File access, network access, and hardware access require explicit entitlement declarations in the `.entitlements` file.

## Common Pitfalls

- **SwiftUI state management**: `@State` is for view-local state only. Shared state belongs in a view model or environment object. Misplacing state causes subtle re-render bugs.
- **Main actor isolation**: UI updates must happen on `@MainActor`. Swift concurrency will enforce this, but older callback-based APIs won't. Wrap explicitly.
- **Xcode project file conflicts**: The `.pbxproj` file is fragile. Avoid manual edits. When adding files, prefer SPM packages or folder references over individual file references when possible.
- **Asset catalogs**: Colors and images go in `Assets.xcassets`. Do not hardcode color values in SwiftUI views.

## Dependencies

Managed via Swift Package Manager. Do not add CocoaPods or Carthage unless there is no SPM alternative.

To add a dependency: Xcode > File > Add Package Dependencies, or edit `Package.swift` if this is a package-based project.

## Testing

- Unit tests go in `ProjectNameTests/`.
- UI tests go in `ProjectNameUITests/`.
- View models should be testable without instantiating views.
- Use `@testable import ProjectName` for internal access.
- Mock protocols, not concrete types.

## Before Committing

1. Build succeeds with zero warnings (`xcodebuild` or Cmd+B).
2. All existing tests pass.
3. No hardcoded strings that should be localized.
4. No API usage below the deployment target without availability checks.
5. Run SwiftLint if configured: `swiftlint lint`.

## Things Claude Should Not Do

- Do not modify the `.pbxproj` file directly. Suggest file additions and let the developer handle project integration.
- Do not assume a specific macOS version unless stated. Always ask or check the deployment target.
- Do not add `import AppKit` to SwiftUI views unless there is a concrete reason.
- Do not generate UIKit code. This is a macOS project.
- Do not suggest Combine unless the project already uses it. Prefer async/await and Swift concurrency.
