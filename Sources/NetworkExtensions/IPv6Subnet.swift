import Foundation

public struct IPv6Subnet {
    public var network: UInt128
    public var prefix: Int
}

public extension IPv6Subnet {

    var end: UInt128 {
        return network | (~prefix.integerMask & .max)
    }

    var hosts: UInt128 {
        return (1...128 - prefix).reduce(UInt128(1), { (result, _) -> UInt128 in return result * 2 })
    }
}

public extension Int {
    var integerMask: UInt128 {
        return UInt128(String(repeating: "1", count: self).padding(toLength: 128, withPad: "0", startingAt: 0), radix: 2)!
    }
}

public extension IPv6Subnet {
    // fe08::8/112
    init?(_ string: String) {
        let splitted = string.split(separator: "/")
        guard splitted.count == 2 else { return nil }
        let hostString = splitted[0]
        let prefixString = splitted[1]

        if let prefix = Int(prefixString), prefix > 0, prefix < 128 {
            self.init(host: String(hostString), prefix: prefix)
        } else {
            return nil
        }
    }

    init?(host: String, prefix: Int) {
        let hostInteger: UInt128 = host.expandedIPv6.IPv6AddressInteger
        self.prefix = prefix
        self.network = hostInteger & prefix.integerMask
    }
}

public extension String {

    var isValidIPv6Address: Bool {
        let pattern = "^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b).){3}(b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b))|(([0-9A-Fa-f]{1,4}:){0,5}:((b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b).){3}(b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b))|(::([0-9A-Fa-f]{1,4}:){0,5}((b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b).){3}(b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$"

        let expression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.count)
        let matches = expression.matches(in: self, options: .reportCompletion, range: range)
        return !matches.isEmpty
    }

    var IPv6AddressInteger: UInt128 {
        return self
            .components(separatedBy: ":")
            .compactMap({ Int($0, radix: 16 ) })
            .reduce(UInt128(0)) { $0 << 16 + UInt128($1) }
    }

    var expandedIPv6: String {
        guard let r: Range<Index> = self.range(of: "::", options: .backwards) else {
            return self
        }

        var expanded: String = self
        let colonCount = self.filter { $0 == ":" }.count

        let lastIndex = r.lowerBound

        for _ in 0...7 - colonCount {
            expanded.insert("0", at: lastIndex)
            expanded.insert(":", at: lastIndex)
        }
        expanded = expanded.replacingOccurrences(of: "::", with: ":")

        return expanded
    }

}

public extension UInt128 {

    var hexString: String {
        let octet1 = String(UInt16((self>>112) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet2 = String(UInt16((self>>96) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet3 = String(UInt16((self>>80) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet4 = String(UInt16((self>>64) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet5 = String(UInt16((self>>48) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet6 = String(UInt16((self>>32) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet7 = String(UInt16((self>>16) & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        let octet8 = String(UInt16(self & 0xffff), radix: 16).leftPadding(toLength: 4, withPad: "0")
        return "\(octet1):\(octet2):\(octet3):\(octet4):\(octet5):\(octet6):\(octet7):\(octet8)"
    }

}

private extension String {
    func leftPadding(toLength lenght: Int, withPad pad: String) -> String {
        let toPad = lenght - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: pad, startingAt: 0) + self
    }
}
