import XCTest
@testable import BrowserSwitchMenuBarApp

final class SystemVPNStatusTests: XCTestCase {
    func testParseConnectedService() {
        let output = """
        Available network connection services in the current set (*=enabled):
        * (Connected) Work VPN [IPSec]
        """

        let status = SystemVPNStatusDetector.parseNCListOutput(output)
        XCTAssertEqual(status, .connected(serviceNames: ["Work VPN [IPSec]"]))
        XCTAssertEqual(status.isConnected, true)
    }

    func testParseDisconnectedWhenNoConnectedEntries() {
        let output = """
        Available network connection services in the current set (*=enabled):
        * (Disconnected) Work VPN [IPSec]
        * (Disconnected) Personal VPN [IKEv2]
        """

        let status = SystemVPNStatusDetector.parseNCListOutput(output)
        XCTAssertEqual(status, .disconnected)
        XCTAssertEqual(status.isConnected, false)
    }

    func testParseUnknownWhenOutputDoesNotContainServiceData() {
        let output = "unexpected output"
        let status = SystemVPNStatusDetector.parseNCListOutput(output)
        XCTAssertEqual(status, .unknown)
        XCTAssertNil(status.isConnected)
    }

    func testParseNetstatDetectsUTUNSplitTunnelRoutes() {
        let output = """
        Routing tables

        Internet:
        Destination        Gateway            Flags               Netif Expire
        0/1                10.31.141.13       UGScg              utun10
        128.0/1            10.31.141.13       UGSc               utun10
        default            172.16.0.1         UGScg                 en0
        """

        let interfaces = SystemVPNStatusDetector.parseNetstatUTUNInterfaces(output)
        XCTAssertEqual(interfaces, ["utun10"])
    }

    func testParseMultipleConnectedServices() {
        let output = """
        Available network connection services in the current set (*=enabled):
        * (Connected) Work VPN [IPSec]
        * (Connected) Home VPN [IKEv2]
        * (Disconnected) Backup VPN [L2TP]
        """

        let status = SystemVPNStatusDetector.parseNCListOutput(output)
        XCTAssertEqual(status, .connected(serviceNames: ["Work VPN [IPSec]", "Home VPN [IKEv2]"]))
    }

    func testParseDisconnectedWhenHeaderPresentButNoServices() {
        let output = "Available network connection services in the current set (*=enabled):\n"

        let status = SystemVPNStatusDetector.parseNCListOutput(output)
        XCTAssertEqual(status, .disconnected)
    }

    func testParseEmptyOutputReturnsUnknown() {
        let status = SystemVPNStatusDetector.parseNCListOutput("")
        XCTAssertEqual(status, .unknown)
    }

    func testParseNetstatDetectsDefaultUTUNRoute() {
        let output = """
        Routing tables

        Internet:
        Destination        Gateway            Flags               Netif Expire
        default            10.0.0.1           UGScg              utun5
        """

        let interfaces = SystemVPNStatusDetector.parseNetstatUTUNInterfaces(output)
        XCTAssertEqual(interfaces, ["utun5"])
    }

    func testParseNetstatDeduplicatesInterfaces() {
        let output = """
        Routing tables

        Internet:
        Destination        Gateway            Flags               Netif Expire
        0/1                10.31.141.13       UGScg              utun10
        128.0/1            10.31.141.13       UGSc               utun10
        10.0.0.0/8         10.31.141.13       UGSc               utun10
        """

        let interfaces = SystemVPNStatusDetector.parseNetstatUTUNInterfaces(output)
        XCTAssertEqual(interfaces, ["utun10"])
    }

    func testParseNetstatReturnsEmptyForEmptyOutput() {
        let interfaces = SystemVPNStatusDetector.parseNetstatUTUNInterfaces("")
        XCTAssertEqual(interfaces, [])
    }

    func testParseNetstatIgnoresNonUTUNRoutes() {
        let output = """
        Routing tables

        Internet:
        Destination        Gateway            Flags               Netif Expire
        default            172.16.0.1         UGScg                 en0
        172.16/21          link#11            UCS                   en0
        """

        let interfaces = SystemVPNStatusDetector.parseNetstatUTUNInterfaces(output)
        XCTAssertEqual(interfaces, [])
    }
}
