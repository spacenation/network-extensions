import Foundation
import Network

public struct IPv4Subnet {
    public let networkAddress: IPv4Address
    public let mask: UInt32

    public init(host: IPv4Address, mask: UInt32) {
        self.networkAddress = IPv4Address(host.intValue & mask)
        self.mask = mask
    }
}

extension IPv4Subnet {
    public var broadcastAddress: IPv4Address {
        return IPv4Address(networkAddress.intValue | (~mask & .max))
    }

    public var prefix: Int {
        return IPv4Address(mask).binaryStringValue.components(separatedBy: "1").count - 1
    }

    public var firstHost: IPv4Address {
        return IPv4Address(networkAddress.intValue + 1)
    }

    public var lastHost: IPv4Address {
        return IPv4Address(broadcastAddress.intValue - 1)
    }
}

extension IPv4Subnet: CustomStringConvertible {
    public var description: String {
        return "\(self.networkAddress)/\(prefix)"
    }
}

@available(iOS 12.0, macOS 10.14, *)
extension IPv4Subnet {
    public init?(_ networkInterface: NWInterface) {
        var address: String?
        var mask: String?
        var interfaceAddress: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&interfaceAddress) == 0 else { return nil }
        guard let firstAddress = interfaceAddress else { return nil }

        for interfacePointer in sequence(first: firstAddress, next: { $0.pointee.ifa_next }) {
            let interface = interfacePointer.pointee
            guard interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) else { continue }
            guard String(cString: interface.ifa_name) == networkInterface.name else { continue }

            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
            address = String(cString: hostname)

            var netmask = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(interface.ifa_netmask, socklen_t(interface.ifa_addr.pointee.sa_len), &netmask, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
            mask = String(cString: netmask)
        }
        freeifaddrs(interfaceAddress)

        guard let addressString = address, let ipv4Address = IPv4Address(addressString) else { return nil }
        guard let maskString = mask, let ipv4Mask = IPv4Address(maskString) else { return nil }

        self.init(host: ipv4Address, mask: ipv4Mask.intValue)
    }
}
