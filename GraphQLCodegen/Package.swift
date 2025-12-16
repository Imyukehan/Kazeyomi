// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "KazeyomiGraphQLCodegen",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "KazeyomiGraphQLCodegen",
            dependencies: []
        )
    ]
)
