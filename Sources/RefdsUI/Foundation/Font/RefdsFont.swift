import SwiftUI

public final class RefdsFont {
    public static var shared = RefdsFont()
    
    public private(set) var fontNames: [RefdsFontFamily: [Font.Weight: String]] = [:]
    
    private init() { registerRefdsFont() }
    
    public func refds(
        size: CGFloat,
        scaledSize: CGFloat,
        family: RefdsFontFamily = .moderat,
        weight: Font.Weight = .regular,
        style: Font.TextStyle = .body
    ) -> Font {
        if fontNames.isEmpty {
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        guard let fontName = fontNames[family]?[weight] else {
            assertionFailure("Unsupported font weight")
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        return customFont(fontName, size: size, style: style)
    }
    
    private func nonScalingSystemFont(size: CGFloat, weight: Font.Weight) -> Font {
        Font.system(size: size, weight: weight)
    }

    private func customFont(_ name: String, size: CGFloat, style: Font.TextStyle = .body) -> Font {
        Font.custom(name, size: size, relativeTo: style) 
    }
    
    private func registerRefdsFont() {
        for family in RefdsFontFamily.allCases {
            var fontNames: [Font.Weight: String] = [:]
            for case let (weight, url?) in family.fonts {
                guard let font = registerFont(at: url) else { continue }
                fontNames[weight] = font.postScriptName as String?
            }
            self.fontNames[family] = fontNames
        }
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font: Font.custom(self.fontNames[.moderat]?[.bold] ?? "", size: 30, relativeTo: .largeTitle)]
    }
    
    private func registerFont(at url: URL) -> CGFont? {
        var error: Unmanaged<CFError>?
        guard let data = try? Data(contentsOf: url),
              let dataProvider = CGDataProvider(data: data as CFData),
              let font = CGFont(dataProvider) else {
            fatalError("Unable to load custom font from \(url)")
        }
        
        if CTFontManagerRegisterGraphicsFont(font, &error) == false {
            print("Custom font registration error: \(String(describing: error))")
        }

        return font
    }
}

extension Font {
    public static func refds(
        size: CGFloat,
        scaledSize: CGFloat,
        family: RefdsFontFamily = .moderat,
        weight: Font.Weight = .regular,
        style: Font.TextStyle = .body
    ) -> Font {
        RefdsFont.shared.refds(
            size: size,
            scaledSize: scaledSize,
            family: family,
            weight: weight,
            style: style
        )
    }
}

public extension ContentSizeCategory {
    var ratio: CGFloat {
        switch self {
        case .extraSmall: return 0.8
        case .small: return 0.85
        case .medium: return 0.9
        case .large: return 1
        case .extraLarge: return 1.1
        case .extraExtraLarge: return 1.2
        case .extraExtraExtraLarge: return 1.35
        case .accessibilityMedium: return 1.6
        case .accessibilityLarge: return 1.9
        case .accessibilityExtraLarge: return 2.35
        case .accessibilityExtraExtraLarge: return 2.75
        case .accessibilityExtraExtraExtraLarge: return 3.1
        @unknown default: return 1
        }
    }
}
