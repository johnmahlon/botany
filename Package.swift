// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "botany",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/DiscordBM/DiscordBM", revision: "52fe13121d24dc9a250fec4fc969ccec06357961"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "botany",
            dependencies: [
                .product(name: "DiscordBM", package: "DiscordBM"),
                .product(name: "SQLite", package: "SQLite.swift")
            ],
            resources: [
                .process("Art") // Include the "art" folder as a resource
            ]
        ),
    ]
)
