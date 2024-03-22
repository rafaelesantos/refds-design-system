# RefdsUI

RefdsUI is a Swift Package designed to streamline the implementation of a design system in SwiftUI. It offers a collection of reusable components and view extensions to enhance your SwiftUI development experience.

## Features

- Components: Includes a variety of pre-built UI components such as toggles, calendars, loading indicators, text views, text fields, buttons, cards, and more.
- View Extensions: Provides extensions on SwiftUI views to simplify common tasks like navigation and binding.

## Installation

Add this project to your `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/rafaelesantos/refds-design-system.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: [
                .product(
                    name: "RefdsUI",
                    package: "refds-design-system"),
            ]),
    ]
)
```
