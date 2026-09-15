// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Context",
    platforms: [
        .macOS("26.0")
    ],
    products: [
        .executable(name: "Context", targets: ["Context"]),
        .executable(name: "ContextDemo", targets: ["ContextDemo"])
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.10.0")
    ],
    targets: [
        .executableTarget(
            name: "Context",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle")
            ],
            path: "Sources/Context"
        ),
        .executableTarget(
            name: "ContextDemo",
            path: "Tools/ContextDemo"
        ),
        .testTarget(
            name: "ContextTests",
            dependencies: ["Context"],
            path: "Tests/ContextTests"
        )
    ]
)
