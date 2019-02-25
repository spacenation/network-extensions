import XCTest
import Subnet
import Network

class IPV4AddressTests: XCTestCase {
    func testInitFromInteger() {
        XCTAssert(IPv4Address(.min) == IPv4Address("0.0.0.0"))
        XCTAssert(IPv4Address(3232235521) == IPv4Address("192.168.0.1"))
        XCTAssert(IPv4Address(.max) == IPv4Address("255.255.255.255"))
    }

    func testConversionToInteger() {
        XCTAssert(IPv4Address("0.0.0.0")?.intValue == .min)
        XCTAssert(IPv4Address("192.168.0.1")?.intValue == 3232235521)
        XCTAssert(IPv4Address("255.255.255.255")?.intValue == .max)
    }
}
