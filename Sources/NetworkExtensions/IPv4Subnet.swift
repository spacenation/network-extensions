import Foundation
import Network

public struct IPv4Subnet {
    public let network: IPv4Address
    public let mask: UInt32

    public init(host: IPv4Address, mask: UInt32) {
        self.network = IPv4Address(host.intValue & mask)
        self.mask = mask
    }
    
    public init?(host: String?, mask: String?) {
        guard
            let host = host, host.isValidIPv4Address,
            let mask = mask, IPv4Subnet.masks.contains(mask.IPv4AddressInteger) else { return nil }
        self.mask = mask.IPv4AddressInteger
        self.network = IPv4Address(host.IPv4AddressInteger & self.mask)
    }
    
    public init?(host: String, prefix: Int) {
        guard host.isValidIPv4Address else { return nil }
        guard prefix > 0, prefix < 32 else { return nil }
        self.init(host: IPv4Address(host.IPv4AddressInteger), mask: IPv4Subnet.masks[prefix])
    }
}

extension IPv4Subnet {
    public static let masks: [UInt32] = Array(0...31).map {
        UInt32(String(repeating: "1", count: $0).padding(toLength: 32, withPad: "0", startingAt: 0), radix: 2)!
    }
}

extension IPv4Subnet {
    public var broadcast: IPv4Address {
        return IPv4Address(network.intValue | (~mask & .max))
    }

    public var prefix: Int {
        return IPv4Address(mask).binaryString.components(separatedBy: "1").count - 1
    }

    public var firstHost: IPv4Address {
        return IPv4Address(network.intValue + 1)
    }

    public var lastHost: IPv4Address {
        return IPv4Address(broadcast.intValue - 1)
    }
    
    public var hosts: UInt32 {
        return UInt32(pow(Double(2), Double(32 - (IPv4Address(mask).binaryString.prefixLenght))) - 2)
    }
}

extension IPv4Subnet: CustomStringConvertible {
    public var description: String {
        return "\(self.network)/\(prefix)"
    }
}
