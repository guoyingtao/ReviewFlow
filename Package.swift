// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReviewKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "ReviewKit",
            targets: ["ReviewKit"]
        ),
    ],
    targets: [
        .target(
            name: "ReviewKit",
            path: "Sources/ReviewKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "ReviewKitTests",
            dependencies: ["ReviewKit"],
            path: "Tests/ReviewKitTests"
        ),
    ]
)
