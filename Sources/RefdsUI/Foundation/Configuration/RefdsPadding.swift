import SwiftUI

public struct RefdsPadding {
    public static var `default`: RefdsPadding { RefdsPadding() }
    
    public var extraSmall: CGFloat
    public var small: CGFloat
    public var medium: CGFloat
    public var large: CGFloat
    public var extraLarge: CGFloat
    
    public init(
        extraSmall: CGFloat = 6,
        small: CGFloat = 12,
        medium: CGFloat = 18,
        large: CGFloat = 24,
        extraLarge: CGFloat = 30
    ) {
        self.extraSmall = extraSmall
        self.small = small
        self.medium = medium
        self.large = large
        self.extraLarge = extraLarge
    }
}

public extension CGFloat {
    enum Padding {
        case extraSmall
        case small
        case medium
        case large
        case extraLarge
        
        var rawValue: CGFloat {
            switch self {
            case .extraSmall: return RefdsUI.shared.padding.extraSmall
            case .small: return RefdsUI.shared.padding.small
            case .medium: return RefdsUI.shared.padding.medium
            case .large: return RefdsUI.shared.padding.large
            case .extraLarge: return RefdsUI.shared.padding.extraLarge
            }
        }
    }
    
    static var cornerRadius: CGFloat {
        RefdsUI.shared.cornerRadius
    }
    
    static func padding(_ padding: Padding) -> CGFloat {
        padding.rawValue
    }
}
