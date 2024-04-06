import SwiftUI

public struct RefdsBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    private let style: Style
    
    public init(style: Style = .background) {
        self.style = style
    }
    
    public func body(content: Content) -> some View {
        content
            .background(color)
    }
    
    private var color: Color {
        switch style {
        case .background: return .background(for: colorScheme)
        case .secondaryBackground: return .secondaryBackground(for: colorScheme)
        }
    }
}

public extension RefdsBackgroundModifier {
    enum Style {
        case background
        case secondaryBackground
    }
}
