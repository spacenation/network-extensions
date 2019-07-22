// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NetworkExtensions",
    platforms: [
        .iOS(.v12), .macOS(.v10_14)
    ],
    products: [
        .library(name: "NetworkExtensions", type: .static, targets: ["NetworkExtensions"])
    ],
    targets: [
        .target(name: "NetworkExtensions"),
        .testTarget(name: "NetworkExtensionsTests", dependencies: ["NetworkExtensions"])
    ]
)
