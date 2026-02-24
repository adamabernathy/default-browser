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

    func testOrderedBundleIDsReturnsEmptyForNoCandidates() {
        let result = BrowserDiscovery.orderedBundleIDs(
            preferredOrder: ["com.apple.Safari"],
            candidates: [],
            homeDirectory: home
        )

        XCTAssertEqual(result, [])
    }

    func testOrderedBundleIDsSortsNonPreferredAlphabetically() {
        let candidates: [BrowserCandidateInfo] = [
            .init(bundleID: "com.example.zebra", appURL: URL(fileURLWithPath: "/Applications/Zebra.app"), displayName: "Zebra"),
            .init(bundleID: "com.example.alpha", appURL: URL(fileURLWithPath: "/Applications/Alpha.app"), displayName: "Alpha")
        ]

        let result = BrowserDiscovery.orderedBundleIDs(
            preferredOrder: [],
            candidates: candidates,
            homeDirectory: home
        )

        XCTAssertEqual(result, ["com.example.alpha", "com.example.zebra"])
    }

    func testInstallLocationRankPrefersSystemApplicationsOverAll() {
        let systemURL = URL(fileURLWithPath: "/Applications/Browser.app")
        let userURL = URL(fileURLWithPath: "/Users/tester/Applications/Browser.app")

        XCTAssertTrue(BrowserDiscovery.isPreferredInstallLocation(systemURL, over: userURL, homeDirectory: home))
    }

    func testInstallLocationRankValues() {
        XCTAssertEqual(
            BrowserDiscovery.installLocationRank(URL(fileURLWithPath: "/Applications/Test.app"), homeDirectory: home),
            0
        )
        XCTAssertEqual(
            BrowserDiscovery.installLocationRank(URL(fileURLWithPath: "/Users/tester/Applications/Test.app"), homeDirectory: home),
            1
        )
        XCTAssertEqual(
            BrowserDiscovery.installLocationRank(URL(fileURLWithPath: "/opt/Test.app"), homeDirectory: home),
            2
        )
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
