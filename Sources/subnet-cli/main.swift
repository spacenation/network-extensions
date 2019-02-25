import Foundation
import Network
import Subnet

let path = NWPathMonitor()

path.pathUpdateHandler = { path in
    guard path.supportsIPv4, let interface = path.availableInterfaces.first, let subnet = IPv4Subnet(interface) else { return }
    print("\(interface.name): \(subnet)")
}
path.start(queue: .main)

RunLoop.main.run()
