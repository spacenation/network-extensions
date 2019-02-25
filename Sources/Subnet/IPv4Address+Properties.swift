import Foundation
import Network

extension IPv4Address {

    public init(_ integer: UInt32) {
        self.init(withUnsafeBytes(of: UInt32(bigEndian: integer)) { Data($0) })!
    }

    public var intValue: UInt32 {
        return UInt32(bigEndian: self.rawValue.withUnsafeBytes { $0.pointee })
    }

    public var stringValue: String {
        let integerValue = self.intValue
        let octet1 = UInt8((integerValue>>24) & 0xff)
        let octet2 = UInt8((integerValue>>16) & 0xff)
        let octet3 = UInt8((integerValue>>8) & 0xff)
        let octet4 = UInt8(integerValue & 0xff)
        return "\(octet1).\(octet2).\(octet3).\(octet4)"
    }

    var binaryStringValue: String {
        let integerValue = self.intValue
        let octet1 = String(UInt8((integerValue>>24) & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        let octet2 = String(UInt8((integerValue>>16) & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        let octet3 = String(UInt8((integerValue>>8) & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        let octet4 = String(UInt8(integerValue & 0xff), radix: 2).leftPadding(toLength: 8, withPad: "0")
        return "\(octet1).\(octet2).\(octet3).\(octet4)"
    }
}

private extension String {
    func leftPadding(toLength lenght: Int, withPad pad: String) -> String {
        let toPad = lenght - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: pad, startingAt: 0) + self
    }
}
