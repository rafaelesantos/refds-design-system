// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RefdsUI",
    products: [
        .library(
            name: "RefdsUI",
            targets: ["RefdsUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RefdsUI",
            dependencies: []),
    ]
)
