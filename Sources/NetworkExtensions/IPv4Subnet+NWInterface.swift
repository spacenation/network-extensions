import Foundation
import Network

@available(iOS 12.0, macOS 10.14, *)
extension IPv4Subnet {
    public init?(_ networkInterface: NWInterface) {
        var address: String?
        var mask: String?
        var interfaceAddress: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&interfaceAddress) == 0 else { return nil }
        guard let firstAddress = interfaceAddress else { return nil }

        sequence(first: firstAddress) { $0.pointee.ifa_next }.forEach { interfacePointer in
            let interface = interfacePointer.pointee
            guard interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) else { return }
            guard String(cString: interface.ifa_name) == networkInterface.name else { return }

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
