import Foundation
import Network

extension IPv4Address {
    public init(_ integer: UInt32) {
        self.init(withUnsafeBytes(of: UInt32(bigEndian: integer)) { Data($0) })!
    }

    public var intValue: UInt32 {
        UInt32(bigEndian: self.rawValue.withUnsafeBytes { $0.load(as: UInt32.self) })
    }
}

extension IPv4Address {
    
    public var ipClass: String {
        self.intValue.ipClass
    }

    public var ipString: String {
        self.intValue.ipString
    }

    public var binaryString: String {
        self.intValue.binaryString
    }
}

public extension UInt32 {

    var ipClass: String {
        switch UInt8((self>>24) & 0xff) {
        case let x where x < 128 : return "A"
        case let x where x < 192 : return "B"
        case let x where x < 224 : return "C"
        case let x where x < 240 : return "D"
        default: return "E"
        }
    }

    var ipString: String {
        let octet1 = UInt8((self>>24) & 0xff)
        let octet2 = UInt8((self>>16) & 0xff)
        let octet3 = UInt8((self>>8) & 0xff)
        let octet4 = UInt8(self & 0xff)
        return "\(octet1).\(octet2).\(octet3).\(octet4)"
    }

    var binaryString: String {
        let octet1 = String(UInt8((self>>24) & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        let octet2 = String(UInt8((self>>16) & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        let octet3 = String(UInt8((self>>8) & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        let octet4 = String(UInt8(self & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        return "\(octet1).\(octet2).\(octet3).\(octet4)"
    }
}

public extension String {
    var isValidIPv4Address: Bool {
        let octets = self.components(separatedBy: ".")
        let nums = octets.compactMap { Int($0) }
        return octets.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    
    var isValidIPv4Mask: Bool {
        let maskInteger = self.IPv4AddressInteger
        return IPv4Subnet.masks.contains(where: { $0 == maskInteger })
    }

    var IPv4AddressInteger: UInt32 {
        return self.components(separatedBy: ".").compactMap({ Int($0) }).reduce(UInt32(0)) { $0 << 8 + UInt32($1) }
    }

    var prefixLenght: Int {
        return components(separatedBy: "1").count - 1
    }
}

private extension String {
    func leftPadding(toLength lenght: Int, withPad pad: String) -> String {
        let toPad = lenght - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: pad, startingAt: 0) + self
    }
}
