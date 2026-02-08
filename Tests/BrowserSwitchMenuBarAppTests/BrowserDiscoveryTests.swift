import XCTest
@testable import BrowserSwitchMenuBarApp

final class BrowserDiscoveryTests: XCTestCase {
    private let home = "/Users/tester"

    func testOrderedBundleIDsPinsSafariAndChromeFirst() {
        let candidates: [BrowserCandidateInfo] = [
            .init(bundleID: "org.mozilla.firefox", appURL: URL(fileURLWithPath: "/Applications/Firefox.app"), displayName: "Firefox"),
            .init(bundleID: "com.google.Chrome", appURL: URL(fileURLWithPath: "/Applications/Google Chrome.app"), displayName: "Google Chrome"),
            .init(bundleID: "com.apple.Safari", appURL: URL(fileURLWithPath: "/Applications/Safari.app"), displayName: "Safari")
        ]

        let result = BrowserDiscovery.orderedBundleIDs(
            preferredOrder: ["com.apple.Safari", "com.google.Chrome"],
            candidates: candidates,
            homeDirectory: home
        )

        XCTAssertEqual(result, ["com.apple.Safari", "com.google.Chrome", "org.mozilla.firefox"])
    }

    func testDeduplicateByDisplayNamePrefersApplicationsFolder() {
        let candidates: [BrowserCandidateInfo] = [
            .init(bundleID: "com.atlas.dev", appURL: URL(fileURLWithPath: "/Users/tester/Applications/ChatGPT Atlas.app"), displayName: "ChatGPT Atlas"),
            .init(bundleID: "com.atlas.release", appURL: URL(fileURLWithPath: "/Applications/ChatGPT Atlas.app"), displayName: "ChatGPT Atlas")
        ]

        let deduped = BrowserDiscovery.deduplicateByDisplayName(candidates, homeDirectory: home)

        XCTAssertEqual(deduped.count, 1)
        XCTAssertEqual(deduped.first?.bundleID, "com.atlas.release")
    }

    func testDeduplicateByDisplayNameIsCaseInsensitiveAndTrimmed() {
        let candidates: [BrowserCandidateInfo] = [
            .init(bundleID: "com.example.alpha", appURL: URL(fileURLWithPath: "/Applications/Alpha.app"), displayName: "  ALPHA Browser  "),
            .init(bundleID: "com.example.beta", appURL: URL(fileURLWithPath: "/Users/tester/Applications/Alpha Browser.app"), displayName: "alpha browser")
        ]

        let deduped = BrowserDiscovery.deduplicateByDisplayName(candidates, homeDirectory: home)

        XCTAssertEqual(deduped.count, 1)
        XCTAssertEqual(deduped.first?.bundleID, "com.example.alpha")
    }

    func testInstallLocationRankPrefersUserApplicationsOverOtherLocations() {
        let userAppsURL = URL(fileURLWithPath: "/Users/tester/Applications/SomeBrowser.app")
        let otherURL = URL(fileURLWithPath: "/opt/SomeBrowser.app")

        XCTAssertTrue(BrowserDiscovery.isPreferredInstallLocation(userAppsURL, over: otherURL, homeDirectory: home))
    }

    func testEmptyDisplayNameFallsBackToBundleIDAndDoesNotDeduplicate() {
        let candidates: [BrowserCandidateInfo] = [
            .init(bundleID: "com.example.one", appURL: URL(fileURLWithPath: "/Applications/One.app"), displayName: "   "),
            .init(bundleID: "com.example.two", appURL: URL(fileURLWithPath: "/Applications/Two.app"), displayName: "")
        ]

        let deduped = BrowserDiscovery.deduplicateByDisplayName(candidates, homeDirectory: home)
        let ids = Set(deduped.map(\.bundleID))

        XCTAssertEqual(ids, Set(["com.example.one", "com.example.two"]))
    }
}
