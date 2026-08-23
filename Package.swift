// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Context",
    platforms: [
        .macOS("26.0")
    ],
    products: [
        .executable(name: "Context", targets: ["Context"])
    ],
    targets: [
        .executableTarget(
            name: "Context",
            path: "Sources/Context"
        ),
        .testTarget(
            name: "ContextTests",
            dependencies: ["Context"],
            path: "Tests/ContextTests"
        )
    ]
)
