import Foundation
import SwiftUI

extension RefdsText {
    public enum Style {
        case largeTitle
        case title1
        case title2
        case title3
        case callout
        case headline
        case subheadline
        case body
        case footnote
        case caption1
        case caption2
        case custom(CGFloat)
        
        public var value: CGFloat {
#if os(iOS)
            switch self {
            case .largeTitle: return 34.0
            case .title1: return 28.0
            case .title2: return 22.0
            case .title3: return 20.0
            case .callout: return 16.0
            case .headline: return 17.0
            case .subheadline: return 15.0
            case .body: return 17.0
            case .footnote: return 13.0
            case .caption1: return 12.0
            case .caption2: return 11.0
            case .custom(let size): return size
            }
#elseif os(macOS)
            switch self {
            case .largeTitle: return 26.0
            case .title1: return 22.0
            case .title2: return 17.0
            case .title3: return 15.0
            case .callout: return 12.0
            case .headline: return 13.0
            case .subheadline: return 11.0
            case .body: return 13.0
            case .footnote: return 10.0
            case .caption1: return 10.0
            case .caption2: return 10.0
            case .custom(let size): return size * 0.7857
            }
#endif
        }
        
        public var textStyle: Font.TextStyle {
            switch self {
            case .largeTitle: return .largeTitle
            case .title1: return .title
            case .title2: return .title2
            case .title3: return .title3
            case .callout: return .callout
            case .headline: return .headline
            case .subheadline: return .subheadline
            case .body: return .body
            case .footnote: return .footnote
            case .caption1: return .caption
            case .caption2: return .caption2
            case .custom(_): return .body
            }
        }
    }
}
