// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReviewFlow",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "ReviewFlow",
            targets: ["ReviewFlow"]
        ),
    ],
    targets: [
        .target(
            name: "ReviewFlow",
            path: "Sources/ReviewFlow",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "ReviewFlowTests",
            dependencies: ["ReviewFlow"],
            path: "Tests/ReviewFlowTests"
        ),
    ]
)
