#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
import UIKit
import SwiftUI

public typealias RefdsImageCrossPlatform = UIImage

extension Image {
    public init(cpImage: RefdsImageCrossPlatform) {
        self.init(uiImage: cpImage)
    }
}

extension UIImage {
    var data: Data? {
        pngData()
    }
}

#elseif os(macOS)
import AppKit
import SwiftUI

public typealias RefdsImageCrossPlatform = NSImage

extension Image {
    public init(cpImage: RefdsImageCrossPlatform) {
        self.init(nsImage: cpImage)
    }
}

extension NSImage {
    var data: Data? {
        tiffRepresentation
    }
}
#endif
