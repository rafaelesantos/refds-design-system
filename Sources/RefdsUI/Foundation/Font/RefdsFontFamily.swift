import Foundation
import SwiftUI

public enum FontFamily: CaseIterable {
    case moderat
    case moderatMono
    
    public var fonts: [Font.Weight: URL?] {
        let family = self == .moderat ? "" : "Mono-"
        return [
            .thin: Bundle.current.url(forResource: "Moderat-\(family)Thin.ttf", withExtension: nil),
            .light: Bundle.current.url(forResource: "Moderat-\(family)Light.ttf", withExtension: nil),
            .regular: Bundle.current.url(forResource: "Moderat-\(family)Regular.ttf", withExtension: nil),
            .medium: Bundle.current.url(forResource: "Moderat-\(family)Medium.ttf", withExtension: nil),
            .bold: Bundle.current.url(forResource: "Moderat-\(family)Bold.ttf", withExtension: nil),
            .black: Bundle.current.url(forResource: "Moderat-\(family)Black.ttf", withExtension: nil)
        ]
    }
}

public enum RefdsFontFamily {
    case moderat
    case moderatMono
    case defaultConfiguration
    
    var font: FontFamily {
        switch self {
        case .moderatMono: return .moderatMono
        case .moderat: return .moderat
        case .defaultConfiguration: return RefdsUI.shared.defaultFontFamily
        }
    }
}
