import SwiftUI
import RefdsCore

public struct RefdsMenu<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    private let content: () -> Content
    private let icon: RefdsIconSymbol?
    private let text: String?
    private let description: String?
    private let detail: String?
    private let font: RefdsText.Style
    private let color: RefdsColor
    private let style: Style
    
    public init(style: Style = .card, color: RefdsColor = .accentColor, icon: RefdsIconSymbol?, text: String?, description: String? = nil, detail: String?, font: RefdsText.Style = .body, @ViewBuilder content:  @escaping () -> Content) {
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
        Menu { content() } label: {
            switch style {
            case .card:
                label
                    .padding()
                    .background(RefdsColor.secondaryBackground(scheme: colorScheme))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
            case .inline: label
            }
        }
    }
    
    private var label: some View {
        HStack(spacing: 0) {
            iconView
            infoView
            Spacer(minLength: 0)
            detailView
            optionIconView
        }
    }
    
    @ViewBuilder
    private var iconView: some View {
        if let icon = icon {
            VStack {
                RefdsIcon(
                    symbol: icon,
                    color: color,
                    size: font.value * 1.2,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
                .frame(
                    width: font.value * 1.3,
                    height: font.value * 1.3
                )
            }.padding(.trailing, 10)
        }
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(alignment: .leading) {
            if let text = text {
                RefdsText(
                    text,
                    style: font,
                    lineLimit: 1
                )
            }
            
            if let description = description, !description.isEmpty {
                RefdsText(
                    description,
                    style: font,
                    color: .secondary,
                    lineLimit: 1
                )
            }
        }.padding(.trailing, 10)
    }
    
    @ViewBuilder
    private var detailView: some View {
        if let detail = detail, !detail.isEmpty {
            RefdsText(
                detail,
                style: font,
                color: .secondary,
                lineLimit: 1
            ).padding(.trailing, 5)
        }
    }
    
    private var optionIconView: some View {
        RefdsIcon(
            symbol: .chevronUpChevronDown,
            color: .secondary.opacity(0.5),
            size: 15,
            renderingMode: .monochrome
        )
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
                        RefdsMenu(icon: .random, text: .randomWord, detail: "\(Int.random(in: 2 ... 12))", font: .footnote) {
                            ForEach(Array(0 ... 5), id: \.self) { _ in
                                RefdsToggle(isOn: .constant(.random())) {
                                    RefdsText(.randomWord)
                                }
                            }
                        }
                        
                        RefdsMenu(icon: .random, text: .randomWord, detail: "\(Int.random(in: 12 ... 16))", font: .footnote) {
                            ForEach(Array(0 ... 5), id: \.self) { _ in
                                RefdsToggle(isOn: .constant(.random())) {
                                    RefdsText(.randomWord)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.horizontal, -30)
            })
        }
    }
}
