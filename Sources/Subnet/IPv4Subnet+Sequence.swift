import Foundation
import Network

extension IPv4Subnet: Sequence {
    public struct Iterator: IteratorProtocol {
        public typealias Element = IPv4Address

        private var currentAddressInteger: UInt32
        private let lastAddressInteger: UInt32

        init(_ subnet: IPv4Subnet) {
            self.currentAddressInteger = subnet.networkAddress.intValue
            self.lastAddressInteger = subnet.broadcastAddress.intValue
        }

        public mutating func next() -> IPv4Address? {
            guard currentAddressInteger + 1 <= lastAddressInteger else { return nil }
            let nextAddressInteger = currentAddressInteger
            currentAddressInteger += 1
            return IPv4Address(nextAddressInteger)
        }
    }

    public func makeIterator() -> IPv4Subnet.Iterator {
        return Iterator(self)
    }
}
