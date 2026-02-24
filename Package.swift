// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BrowserSwitchMenuBarApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "BrowserSwitchMenuBarApp", targets: ["BrowserSwitchMenuBarApp"])
    ],
    targets: [
        .executableTarget(
            name: "BrowserSwitchMenuBarApp",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("CoreServices"),
                .linkedFramework("Network")
            ]
        ),
        .testTarget(
            name: "BrowserSwitchMenuBarAppTests",
            dependencies: ["BrowserSwitchMenuBarApp"]
        )
    ]
)
