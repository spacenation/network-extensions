import Foundation
import Network

extension IPv4Subnet {
    public func scanHTTPHostsWithURL(path: String?, dataMatching: @escaping (String) -> Bool = { _ in true }, limit: Int = 256, completionHandler: @escaping ([String]) -> Void) {
        DispatchQueue(label: "subnet.scan").async {
            var mathchingHosts: [String] = []
            var remainingHosts: Set<String> = Set(self.map { $0.stringValue }.prefix(limit))

            self.prefix(limit).forEach { address in
                let urlString: String
                if let path = path {
                    urlString = "http://\(address.stringValue)/\(path)"
                } else {
                    urlString = "http://\(address.stringValue)"
                }
                guard let url = URL(string: urlString) else {
                    remainingHosts.remove(address.stringValue)
                    return
                }

                let request = URLRequest(url: url, timeoutInterval: 10)
                let task = URLSession.shared.dataTask(with: request) { data, _, _ in
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        if dataMatching(dataString) {
                            mathchingHosts.append(address.stringValue)
                        }
                    }
                    remainingHosts.remove(address.stringValue)
                }
                task.resume()
            }
            while !remainingHosts.isEmpty {
                sleep(1)
            }
            DispatchQueue.main.async {
                completionHandler(mathchingHosts)
            }
        }
    }
}
