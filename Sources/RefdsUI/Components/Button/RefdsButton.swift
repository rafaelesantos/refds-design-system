import SwiftUI

public struct RefdsButton: View {
    private let title: String
    private let color: RefdsColor
    private let style: Style
    private let content: (() -> any View)?
    private let action: (() -> Void)?
    private let maxSize: Bool
    
    public init(
        _ title: String,
        color: RefdsColor = .accentColor,
        style: Style = .primary,
        maxSize: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title.uppercased()
        self.color = color
        self.style = style
        self.action = action
        self.maxSize = maxSize
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
        self.maxSize = false
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
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
    
    private var secondary: some View {
        Button { pressButton() } label: {
            titleView(color: color)
        }
        .overlay {
            RoundedRectangle(cornerRadius: .cornerRadius)
                .stroke(color, lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
    
    private var tertiary: some View {
        Button { pressButton() } label: {
            titleView(color: color)
        }
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
    
    private func titleView(color: RefdsColor = .white, background: RefdsColor? = nil) -> some View {
        HStack {
            RefdsText(title, style: .footnote, color: color, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .frame(height: 48)
                .padding(.padding(.small))
                .if(background == nil) { view in
                    view.background()
                }
                .if(background != nil) { view in
                    view.background(background)
                }
        }
        .padding(.padding(.small) * -1)
    }
    
    @ViewBuilder
    private var custom: some View {
        if let content = content {
            Button { pressButton() } label: {
                HStack {
                    AnyView(content())
                        .padding(.padding(.small))
                        #if os(macOS)
                        .background()
                        #endif
                }
                .padding(.padding(.small) * -1)
            }
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
        }
    }
    
    private func pressButton() {
        self.action?()
    }
}

public extension RefdsButton {
    enum Style {
        case primary
        case secondary
        case tertiary
        case custom
    }
}

public extension View {
    @ViewBuilder
    func refdsDisable(_ disable: Bool = true) -> some View {
        self.disabled(disable)
            .overlay {
                RoundedRectangle(cornerRadius: .cornerRadius)
                    .fill(.black.opacity(0.3))
            }
    }
}

struct RefdsButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .padding(.medium)) {
            RefdsButton("Presentation Button", style: .primary)
            RefdsButton("Presentation Button", style: .secondary)
            RefdsButton("Presentation Button", style: .tertiary)
            RefdsButton("Presentation Button", style: .primary).refdsDisable()
            RefdsButton {
                HStack {
                    RefdsIcon(.infinity)
                    RefdsText("Infinity")
                }
            }
        }
        .padding()
    }
}
