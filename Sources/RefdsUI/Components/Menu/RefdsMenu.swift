import SwiftUI
import RefdsShared

public struct RefdsMenu<Content: View>: View {
    private let content: () -> Content
    private let icon: RefdsIconSymbol?
    private let text: String?
    private let description: String?
    private let detail: String?
    private let font: Font.TextStyle
    private let color: RefdsColor
    private let style: Style
    
    public init(
        style: Style = .card,
        color: RefdsColor = RefdsUI.shared.accentColor,
        icon: RefdsIconSymbol?,
        text: String?,
        description: String? = nil,
        detail: String?,
        font: Font.TextStyle = .body,
        @ViewBuilder content:  @escaping () -> Content
    ) {
        self.color = color
        self.content = content
        self.icon = icon
        self.text = text
        self.description = description
        self.detail = detail
        self.font = font
        self.style = style
    }
    
    public var body: some View {
        switch style {
        case .card: card
        case .inline: inline
        }
    }
    
    private var card: some View {
        HStack(spacing: 0) {
            iconView
            Menu { content() } label: { label }
        }
        .padding(.horizontal)
        .padding(.vertical, .padding(.small))
        .refdsSecondaryBackground()
        .cornerRadius(.cornerRadius)
    }
    
    private var inline: some View {
        HStack(spacing: 0) {
            iconView
            Menu { content() } label: { label }
        }
    }
    
    private var label: some View {
        HStack(spacing: 0) {
            infoView
            Spacer(minLength: 0)
            detailView
            optionIconView
        }
    }
    
    @ViewBuilder
    private var iconView: some View {
        #if os(macOS)
        #else
        if let icon = icon {
            VStack {
                RefdsIcon(
                    icon,
                    color: color,
                    style: font,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
                .padding(.padding(.extraSmall))
                .background(color.opacity(0.1))
                .cornerRadius(.cornerRadius)
            }
            .padding(.trailing, .padding(.small))
        }
        #endif
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(alignment: .leading) {
            if let text = text {
                RefdsText(text, style: font)
            }
            
            if let description = description, !description.isEmpty {
                RefdsText(description, style: font, color: .secondary)
            }
        }
        .padding(.trailing, .padding(.small))
    }
    
    @ViewBuilder
    private var detailView: some View {
        if let detail = detail, !detail.isEmpty {
            RefdsText(
                detail,
                style: font,
                color: .secondary,
                weight: .medium
            )
            .padding(.trailing, .padding(.small))
        }
    }
    
    @ViewBuilder
    private var optionIconView: some View {
        #if os(macOS)
        #else
        RefdsIcon(
            .chevronUpChevronDown,
            color: .secondary.opacity(0.5),
            style: font,
            renderingMode: .monochrome
        )
        #endif
    }
}

public extension RefdsMenu {
    enum Style {
        case inline
        case card
    }
}

struct RefdsMenu_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section(content: {}, footer: {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        RefdsMenu(icon: .random, text: .someWord(), detail: "\(Int.random(in: 2 ... 12))", font: .footnote) {
                            ForEach(Array(0 ... 5), id: \.self) { _ in
                                RefdsToggle(isOn: .constant(.random())) {
                                    RefdsText(.someWord())
                                }
                            }
                        }
                        
                        RefdsMenu(icon: .random, text: .someWord(), detail: "\(Int.random(in: 12 ... 16))", font: .footnote) {
                            ForEach(Array(0 ... 5), id: \.self) { _ in
                                RefdsToggle(isOn: .constant(.random())) {
                                    RefdsText(.someWord())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.horizontal, -30)
            })
            Section {
                RefdsMenu(style: .inline, icon: .random, text: .someWord(), detail: "\(Int.random(in: 2 ... 12))", font: .footnote) {
                    ForEach(Array(0 ... 5), id: \.self) { _ in
                        RefdsToggle(isOn: .constant(.random())) {
                            RefdsText(.someWord())
                        }
                    }
                }
                
                RefdsMenu(style: .inline, icon: .random, text: .someWord(), detail: "\(Int.random(in: 12 ... 16))", font: .footnote) {
                    ForEach(Array(0 ... 5), id: \.self) { _ in
                        RefdsToggle(isOn: .constant(.random())) {
                            RefdsText(.someWord())
                        }
                    }
                }
            }
        }
    }
}
