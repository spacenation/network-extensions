import Network
import NetworkExtensions
import XCTest

class IPv4SubnetTests: XCTestCase {

    func testConvenienceInit() {
        XCTAssert("192.168.0.1".isValidIPv4Address)
        XCTAssertFalse("192.168.0.D".isValidIPv4Address)
        XCTAssertFalse("...".isValidIPv4Address)
        XCTAssert("192.168.0.1".IPv4AddressInteger == 3232235521)

        if let subnet = IPv4Subnet(host: "192.168.0.1", prefix: 24) {
            XCTAssert(subnet.network.ipString == "192.168.0.0")
            XCTAssert(IPv4Address(subnet.mask).ipString == "255.255.255.0")
        } else {
            XCTFail()
        }

        if let subnet = IPv4Subnet(host: "192.168.0.1", mask: "255.255.255.0") {
            XCTAssert(subnet.network.ipString == "192.168.0.0")
            XCTAssert(IPv4Address(subnet.mask).ipString == "255.255.255.0")
        } else {
            XCTFail()
        }
    }

    func testSubnetCalculations() {
        /// Host: 192.168.0.1, MASK: 255.255.255.0
        if let subnet = IPv4Subnet(host: "192.168.0.1", mask: "255.255.255.0") {
            /// Test mask, should be 255.255.255.0
            XCTAssert(subnet.mask == 4294967040)
            XCTAssert(IPv4Address(subnet.mask).ipString == "255.255.255.0")
            XCTAssert(IPv4Address(subnet.mask).binaryString == "11111111.11111111.11111111.00000000")
            XCTAssert(IPv4Address(subnet.mask).binaryString.prefixLenght == 24)

            /// Test network, should be 192.168.0.0
            XCTAssert(subnet.network.intValue == 3232235520)
            XCTAssert(subnet.network.ipString == "192.168.0.0")
            XCTAssert(subnet.network.binaryString == "11000000.10101000.00000000.00000000")
            XCTAssert(subnet.network.ipClass == "C")

            /// Test broadcast, should be 192.168.0.255
            XCTAssert(subnet.broadcast.intValue == 3232235775)
            XCTAssert(subnet.broadcast.ipString == "192.168.0.255")
            XCTAssert(subnet.broadcast.binaryString == "11000000.10101000.00000000.11111111")

            /// Test hosts
            XCTAssert(subnet.hosts == 254)

            /// Test minHost, should be 192.168.0.1
            XCTAssert(subnet.firstHost.intValue == 3232235521)
            XCTAssert(subnet.firstHost.ipString == "192.168.0.1")
            XCTAssert(subnet.firstHost.binaryString == "11000000.10101000.00000000.00000001")

            /// Test maxHost, should be 192.168.0.254
            XCTAssert(subnet.lastHost.intValue == 3232235774)
            XCTAssert(subnet.lastHost.ipString == "192.168.0.254")
            XCTAssert(subnet.lastHost.binaryString == "11000000.10101000.00000000.11111110")
        } else {
            XCTFail()
        }
    }
    
    func testIterator() {
        let subnet = IPv4Subnet(host: IPv4Address("192.168.0.1")!, mask: IPv4Address("255.255.255.0")!.intValue)
        let hostAddresses = Array(subnet)
        XCTAssert(hostAddresses.count == 254)
    }
}
