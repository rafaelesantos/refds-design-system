import SwiftUI

public struct RefdsButton: View {
    private let title: String
    private let backGroundColor: Color
    private let textColor: Color
    private let style: Style
    private let content: (() -> any View)?
    private let action: (() -> Void)?
    private let hasLargeSize: Bool
    private let isDisable: Bool
    
    public init(
        _ title: String,
        color: Color = .accentColor,
        style: Style = .primary,
        hasLargeSize: Bool = true,
        isDisable: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title.uppercased()
        self.backGroundColor = color
        self.textColor = .white
        self.style = style
        self.action = action
        self.hasLargeSize = hasLargeSize
        self.isDisable = isDisable
        self.content = nil
    }
    
    public init(
        _ title: String,
        backGroundColor: Color = .clear,
        textColor: Color = .accentColor,
        style: Style = .primary,
        hasLargeSize: Bool = true,
        isDisable: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title.uppercased()
        self.backGroundColor = backGroundColor
        self.textColor = textColor
        self.style = style
        self.action = action
        self.hasLargeSize = hasLargeSize
        self.isDisable = isDisable
        self.content = nil
    }
    
    public init(
        isDisable: Bool = false,
        action: (() -> Void)? = nil,
        label: (() -> any View)? = nil
    ) {
        self.title = ""
        self.backGroundColor = .accentColor
        self.textColor = .white
        self.style = .custom
        self.content = label
        self.action = action
        self.hasLargeSize = false
        self.isDisable = isDisable
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
            titleView(
                color: textColor,
                background: backGroundColor
            )
        }
        .disabled(isDisable)
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
    
    private var secondary: some View {
        Button { pressButton() } label: {
            titleView(color: backGroundColor)
        }
        .disabled(isDisable)
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
        .refdsBorder(color: backGroundColor, padding: .zero)
    }
    
    private var tertiary: some View {
        Button { pressButton() } label: {
            titleView(color: textColor)
        }
        .disabled(isDisable)
    }
    
    private func titleView(
        color: Color = .white,
        background: Color? = nil
    ) -> some View {
        HStack {
            RefdsText(
                title,
                style: .footnote,
                color: isDisable ? .secondary : color,
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            .frame(maxWidth: hasLargeSize ? .infinity : nil)
            .frame(height: 48)
            .padding(.padding(.small))
            .if(background == nil) { $0.background() }
            .if(background != nil) { $0.background(isDisable ? background?.opacity(0.1) : background) }
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
            .disabled(isDisable)
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
        RefdsButton(.someWord(), style: .primary, isDisable: true)
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
