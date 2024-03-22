import SwiftUI

public struct RefdsButton: View {
    private let title: String
    private let color: RefdsColor
    private let style: Style
    private let content: (() -> any View)?
    private let action: (() -> Void)?
    private let hasLargeSize: Bool
    
    public init(
        _ title: String,
        color: RefdsColor = .accentColor,
        style: Style = .primary,
        hasLargeSize: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title.uppercased()
        self.color = color
        self.style = style
        self.action = action
        self.hasLargeSize = hasLargeSize
        self.content = nil
    }
    
    public init(
        action: (() -> Void)? = nil,
        label: (() -> any View)? = nil
    ) {
        self.title = ""
        self.color = .accentColor
        self.style = .custom
        self.content = label
        self.action = action
        self.hasLargeSize = false
    }
    
    public var body: some View {
        Group {
            switch style {
            case .primary: primary
            case .secondary: secondary
            case .tertiary: tertiary
            case .custom: custom
            }
        }
    }
    
    private var primary: some View {
        Button { pressButton() } label: {
            titleView(background: color)
        }
        .clipShape(.rect(cornerRadius: .cornerRadius))
    }
    
    private var secondary: some View {
        Button { pressButton() } label: {
            titleView(color: color)
        }
        .clipShape(.rect(cornerRadius: .cornerRadius))
        .refdsBorder(color: color, padding: .zero)
    }
    
    private var tertiary: some View {
        Button { pressButton() } label: {
            titleView(color: color)
        }
    }
    
    private func titleView(
        color: RefdsColor = .white,
        background: RefdsColor? = nil
    ) -> some View {
        HStack {
            RefdsText(
                title,
                style: .footnote,
                color: color,
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            .frame(maxWidth: hasLargeSize ? .infinity : nil)
            .frame(height: 48)
            .padding(.padding(.small))
            .if(background == nil) { $0.background() }
            .if(background != nil) { $0.background(background) }
        }
        .padding(.padding(.small) * -1)
    }
    
    @ViewBuilder
    private var custom: some View {
        if let content = content {
            Button { pressButton() } label: {
                Group {
                    AnyView(content())
                        .padding(.padding(.small))
                        #if os(macOS)
                        .background()
                        #endif
                }
                .padding(.padding(.small) * -1)
            }
        }
    }
    
    private func pressButton() { self.action?() }
}

public extension RefdsButton {
    enum Style {
        case primary
        case secondary
        case tertiary
        case custom
    }
}

#Preview {
    VStack(spacing: .padding(.medium)) {
        RefdsButton(.someWord(), style: .primary)
        RefdsButton(.someWord(), style: .secondary)
        RefdsButton(.someWord(), style: .tertiary)
        RefdsButton {} label: {
            HStack {
                RefdsIcon(.random)
                RefdsText(.someWord())
            }
        }
        .refdsCard()
    }
    .padding(.padding(.large))
}
