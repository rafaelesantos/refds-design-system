import SwiftUI
import RefdsCore

public struct RefdsMenu<Content: View>: View {
    private let content: () -> Content
    private let icon: RefdsIconSymbol?
    private let text: String?
    private let description: String?
    private let detail: String?
    private let font: RefdsText.Style
    private let color: RefdsColor
    
    public init(color: RefdsColor = .accentColor, icon: RefdsIconSymbol?, text: String?, description: String? = nil, detail: String?, font: RefdsText.Style = .body, @ViewBuilder content:  @escaping () -> Content) {
        self.color = color
        self.content = content
        self.icon = icon
        self.text = text
        self.description = description
        self.detail = detail
        self.font = font
    }
    
    public var body: some View {
        Menu { content() } label: {
            HStack(spacing: 15) {
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
                    }
                }
                
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
                }
                
                Spacer(minLength: 0)
                
                if let detail = detail, !detail.isEmpty {
                    RefdsText(
                        detail,
                        style: font,
                        color: .secondary,
                        lineLimit: 1
                    )
                }
                RefdsIcon(
                    symbol: .chevronUpChevronDown,
                    color: .secondary.opacity(0.5),
                    size: 15,
                    weight: .bold,
                    renderingMode: .monochrome
                )
            }
        }
    }
}

struct RefdsMenu_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RefdsMenu(icon: .random, text: .randomWord, description: .randomParagraph, detail: "\(Int.random(in: 2 ... 12))", font: .footnote) {
                ForEach(Array(0 ... 5), id: \.self) { _ in
                    RefdsToggle(isOn: .constant(.random())) {
                        RefdsText(.randomWord)
                    }
                }
            }
        }
    }
}
