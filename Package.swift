// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RefdsUI",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .tvOS(.v15),
        .macOS(.v12)
    ],
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
            resources: [
                .copy("Resource/Fonts/Moderat-Thin.ttf"),
                .copy("Resource/Fonts/Moderat-Light.ttf"),
                .copy("Resource/Fonts/Moderat-Regular.ttf"),
                .copy("Resource/Fonts/Moderat-Medium.ttf"),
                .copy("Resource/Fonts/Moderat-Bold.ttf"),
                .copy("Resource/Fonts/Moderat-Black.ttf"),
                .copy("Resource/Fonts/Moderat-Mono-Thin.ttf"),
                .copy("Resource/Fonts/Moderat-Mono-Light.ttf"),
                .copy("Resource/Fonts/Moderat-Mono-Regular.ttf"),
                .copy("Resource/Fonts/Moderat-Mono-Medium.ttf"),
                .copy("Resource/Fonts/Moderat-Mono-Bold.ttf"),
                .copy("Resource/Fonts/Moderat-Mono-Black.ttf")
            ]),
    ]
)
