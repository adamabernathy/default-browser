import XCTest
@testable import BrowserSwitchMenuBarApp

final class InternetInfoTests: XCTestCase {
    func testDecodeMapsPrimaryFieldsFromServiceResponse() throws {
        let json = """
        {
          "YourFuckingIPAddress": "1.2.3.4",
          "YourFuckingLocation": "Salt Lake City, UT, United States",
          "YourFuckingISP": "Example ISP",
          "YourFuckingTorExit": false
        }
        """

        let info = try XCTUnwrap(InternetInfoDecoder.decode(from: Data(json.utf8)))

        XCTAssertEqual(info.ipAddress, "1.2.3.4")
        XCTAssertEqual(info.isp, "Example ISP")
        XCTAssertEqual(info.location, "Salt Lake City, UT, United States")
        XCTAssertNil(info.vpn)
        XCTAssertEqual(info.torExit, false)
    }

    func testDecodeFallsBackToCityAndCountryWhenLocationMissing() throws {
        let json = """
        {
          "YourFuckingIPAddress": "1.2.3.4",
          "YourFuckingISP": "Example ISP",
          "YourFuckingCity": "Portland",
          "YourFuckingCountry": "United States"
        }
        """

        let info = try XCTUnwrap(InternetInfoDecoder.decode(from: Data(json.utf8)))
        XCTAssertEqual(info.location, "Portland, United States")
    }

    func testDecodeReturnsNilForInvalidJSON() {
        let info = InternetInfoDecoder.decode(from: Data("not json".utf8))
        XCTAssertNil(info)
    }

    func testDecodeReturnsNilForEmptyData() {
        let info = InternetInfoDecoder.decode(from: Data())
        XCTAssertNil(info)
    }

    func testDecodeTrimsWhitespaceFromFields() throws {
        let json = """
        {
          "YourFuckingIPAddress": "  10.0.0.1  ",
          "YourFuckingISP": "  Trimmed ISP  ",
          "YourFuckingLocation": "  Trimmed Location  "
        }
        """

        let info = try XCTUnwrap(InternetInfoDecoder.decode(from: Data(json.utf8)))
        XCTAssertEqual(info.ipAddress, "10.0.0.1")
        XCTAssertEqual(info.isp, "Trimmed ISP")
        XCTAssertEqual(info.location, "Trimmed Location")
    }

    func testDecodeTreatsEmptyStringsAsNil() throws {
        let json = """
        {
          "YourFuckingIPAddress": "",
          "YourFuckingISP": "   ",
          "YourFuckingLocation": ""
        }
        """

        let info = try XCTUnwrap(InternetInfoDecoder.decode(from: Data(json.utf8)))
        XCTAssertNil(info.ipAddress)
        XCTAssertNil(info.isp)
        XCTAssertNil(info.location)
    }

    func testDecodeIncludesVPNField() throws {
        let json = """
        {
          "YourFuckingIPAddress": "1.2.3.4",
          "YourFuckingISP": "Example ISP",
          "YourFuckingVPN": true
        }
        """

        let info = try XCTUnwrap(InternetInfoDecoder.decode(from: Data(json.utf8)))
        XCTAssertEqual(info.vpn, true)
    }

    func testMenuLinesOnlyHideIPWhenNoTorValue() {
        let info = InternetInfo(
            ipAddress: "1.2.3.4",
            isp: "Example ISP",
            location: "Portland, United States",
            vpn: true,
            torExit: nil
        )

        XCTAssertEqual(
            info.menuLines(),
            [
                .init(title: "IP: 1.2.3.4", isHiddenWithoutOptionKey: true),
                .init(title: "ISP: Example ISP", isHiddenWithoutOptionKey: false),
                .init(title: "Location: Portland, United States", isHiddenWithoutOptionKey: false)
            ]
        )
    }

    func testMenuLinesHideIPAndTorExitWithoutOptionKey() {
        let info = InternetInfo(
            ipAddress: "1.2.3.4",
            isp: "Example ISP",
            location: "Portland, United States",
            vpn: nil,
            torExit: true
        )

        XCTAssertEqual(
            info.menuLines(),
            [
                .init(title: "IP: 1.2.3.4", isHiddenWithoutOptionKey: true),
                .init(title: "ISP: Example ISP", isHiddenWithoutOptionKey: false),
                .init(title: "Location: Portland, United States", isHiddenWithoutOptionKey: false),
                .init(title: "Tor Exit: Yes", isHiddenWithoutOptionKey: true)
            ]
        )
    }

    func testMenuLinesReturnsEmptyForAllNilFields() {
        let info = InternetInfo(
            ipAddress: nil,
            isp: nil,
            location: nil,
            vpn: nil,
            torExit: nil
        )

        XCTAssertEqual(info.menuLines(), [])
    }

    func testMenuLinesTorExitFalseShowsNo() {
        let info = InternetInfo(
            ipAddress: nil,
            isp: nil,
            location: nil,
            vpn: nil,
            torExit: false
        )

        XCTAssertEqual(
            info.menuLines(),
            [.init(title: "Tor Exit: No", isHiddenWithoutOptionKey: true)]
        )
    }
}
