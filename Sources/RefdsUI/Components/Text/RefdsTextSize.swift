import Foundation
import SwiftUI

extension RefdsText {
    public enum Size {
        case extraSmall
        case small
        case normal
        case large
        case extraLarge
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
            case .extraSmall: return 12
            case .small: return 14
            case .normal: return 16
            case .large: return 18
            case .extraLarge: return 20
            case .custom(let size): return size
            }
        }
        
        public var textStyle: Font.TextStyle {
            switch self {
            case .extraSmall: return .footnote
            case .small: return .footnote
            case .normal: return .body
            case .large: return .title3
            case .extraLarge: return .largeTitle
            case .custom: return .body
            }
        }
    }
}
