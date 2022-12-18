import Foundation
import SwiftUI

private class CurrentBundleFinder {}

public extension Bundle {
    static var current: Bundle = {
        let bundleName = "RefdsUI_RefdsUI"
        let candidates = [
            main.resourceURL,
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            main.bundleURL,
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }

            let bundleRootPath = candidate?.appendingPathComponent("../" + bundleName + ".bundle")
            if let bundle = bundleRootPath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("unable to find bundle named \(bundleName)")
    }()
}
