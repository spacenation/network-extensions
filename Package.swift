// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Subnet",
    products: [
        .executable(name: "subnet", targets: ["subnet-cli", "Subnet"]),
        .library(name: "Subnet", type: .static, targets: ["Subnet"])
    ],
    targets: [
        .target(name: "subnet-cli", dependencies: ["Subnet"]),
        .target(name: "Subnet"),
        .testTarget(name: "SubnetTests", dependencies: ["Subnet"])
    ]
)
