import XCTest
import Subnet
import Network

class IPv4SubnetTests: XCTestCase {
    func testSubnetCalculations() {
        let subnet = IPv4Subnet(host: IPv4Address("192.168.0.1")!, mask: IPv4Address("255.255.255.0")!.intValue)
        XCTAssert(subnet.networkAddress.stringValue == "192.168.0.0")
        XCTAssert(subnet.prefix == 24)
        XCTAssert(subnet.broadcastAddress.stringValue == "192.168.0.255")
        XCTAssert(subnet.broadcastAddress.stringValue == "192.168.0.255")
        XCTAssert(subnet.firstHost.stringValue == "192.168.0.1")
        XCTAssert(subnet.lastHost.stringValue == "192.168.0.254")
    }

    func testIterator() {
        let subnet = IPv4Subnet(host: IPv4Address("192.168.0.1")!, mask: IPv4Address("255.255.255.0")!.intValue)
        let hostAddresses = subnet.map({ $0 })
        XCTAssert(hostAddresses.count == 255)
    }
}
