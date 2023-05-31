import SwiftUI

public final class RefdsFont {
    public static var shared = RefdsFont()
    
    public private(set) var fontNames: [FontFamily: [Font.Weight: String]] = [:]
    
    private init() { registerRefdsFont() }
    
    public func refds(
        size: CGFloat,
        scaledSize: CGFloat,
        family: RefdsFontFamily = .defaultConfiguration,
        weight: Font.Weight = .regular,
        style: Font.TextStyle = .body
    ) -> Font {
        if fontNames.isEmpty {
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }
        
        guard let fontName = fontNames[family.font]?[weight] else {
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
        for family in FontFamily.allCases {
            var fontNames: [Font.Weight: String] = [:]
            for case let (weight, url?) in family.fonts {
                guard let font = registerFont(at: url) else { continue }
                fontNames[weight] = font.postScriptName as String?
            }
            self.fontNames[family] = fontNames
        }
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
        family: RefdsFontFamily = .defaultConfiguration,
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

#if os(iOS)
extension Font.Weight {
    public var uiKit: UIFont.Weight {
        switch self {
        case .regular: return .regular
        case .bold: return .bold
        case .medium: return .medium
        case .black: return .black
        default: return .regular
        }
    }
}

public extension UIFont {
    enum Size: Int, Comparable {
        #if os(iOS)
        case largeTitle = 34
        case title1 = 28
        case title2 = 22
        case title3 = 20
        case callout = 16
        case headline = 18
        case subheadline = 15
        case body = 17
        case footnote = 13
        case caption1 = 12
        case caption2 = 11
        #elseif os(macOS)
        case largeTitle = 26
        case title1 = 22
        case title2 = 17
        case title3 = 15
        case callout = 12
        case headline = 14
        case subheadline = 11
        case body = 13
        case footnote = 10
        case caption1 = 9
        case caption2 = 8
        #endif

        public static func < (lhs: Size, rhs: Size) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        public var cgFloat: CGFloat {
            CGFloat(self.rawValue)
        }
    }
    
    static func refds(size: UIFont.Size = .body, weight: Weight = .regular, family: RefdsFontFamily = .moderat) -> UIFont {
        if RefdsFont.shared.fontNames.isEmpty {
            return .systemFont(ofSize: size.cgFloat, weight: weight)
        }

        guard let fontName = RefdsFont.shared.fontNames[family.font]?[weight.swiftUI], let font = UIFont(name: fontName, size: size.cgFloat) else {
            assertionFailure("Unsupported font weight")
            return .systemFont(ofSize: size.cgFloat, weight: weight)
        }

        return font
    }

    static var refds: UIFont {
        refds(size: .body, weight: .regular, family: .moderat)
    }
}

private extension UIFont.Weight {
    var swiftUI: Font.Weight {
        switch self {
        case .regular: return .regular
        case .bold: return .bold
        case .medium: return .medium
        case .black: return .black
        default: return .regular
        }
    }
}
#endif
