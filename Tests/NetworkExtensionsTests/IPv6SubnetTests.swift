import XCTest
import NetworkExtensions

class IPv6SubnetTests: XCTestCase {

    func testInitWithString() {
        if let subnet = IPv6Subnet("fe08::8/112") {
            /// Stored
            XCTAssert(subnet.network.hexString == "fe08:0000:0000:0000:0000:0000:0000:0000")
            XCTAssert(subnet.prefix.integerMask.hexString == "ffff:ffff:ffff:ffff:ffff:ffff:ffff:0000")
            /// Calculated
            XCTAssert(subnet.end.hexString == "fe08:0000:0000:0000:0000:0000:0000:ffff")

            XCTAssert(subnet.hosts == 65536)

        } else {
            XCTFail()
        }
    }

    func testInitWithStringVariation2() {
        if let subnet = IPv6Subnet("ffff:ffff:ffff:ffff:ffff:ffff:ffff:0000/1") {
            /// Stored
            XCTAssert(subnet.network.hexString == "8000:0000:0000:0000:0000:0000:0000:0000")
            print(subnet.prefix.integerMask.hexString)
            XCTAssert(subnet.prefix.integerMask.hexString == "8000:0000:0000:0000:0000:0000:0000:0000")
            /// Calculated
            XCTAssert(subnet.end.hexString == "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff")

            XCTAssert(subnet.hosts == UInt128("170141183460469231731687303715884105728"))

        } else {
            XCTFail()
        }
    }

    func testValidations() {
        XCTAssert("2001:4860:4860::8888".isValidIPv6Address)
        XCTAssert("fe80::0".isValidIPv6Address)
        XCTAssert("fe08:0000:0000:0000:0000:0000:0000:ffff".isValidIPv6Address)
        XCTAssertFalse("NOT".isValidIPv6Address)
    }

    func testIPv6Convertions() {
        XCTAssert(UInt128("42541956123769884636017138956568135816").hexString == "2001:4860:4860:0000:0000:0000:0000:8888")
        print("2001:4860:4860::8888".expandedIPv6)
        XCTAssert("2001:4860:4860::8888".expandedIPv6 == "2001:4860:4860:0:0:0:0:8888")
        print("2001:4860:4860:0000:0000:0000:0000:8888".IPv6AddressInteger)
        XCTAssert("2001:4860:4860:0000:0000:0000:0000:8888".IPv6AddressInteger == UInt128("42541956123769884636017138956568135816"))
        XCTAssert(Int("FFFF", radix: 16) == 65535)
    }
}
