import SwiftUI
import RefdsCore

public struct RefdsMenu<Content: View>: View {
    private let content: () -> Content
    private let icon: RefdsIconSymbol?
    private let text: String?
    private let description: String?
    private let detail: String?
    private let font: RefdsText.Style
    
    public init(icon: RefdsIconSymbol?, text: String?, description: String? = nil, detail: String?, font: RefdsText.Style = .body, @ViewBuilder content:  @escaping () -> Content) {
        self.content = content
        self.icon = icon
        self.text = text
        self.description = description
        self.detail = detail
        self.font = font
    }

    public var body: some View {
        HStack(spacing: 15) {
            if let icon = icon {
                RefdsIcon(
                    symbol: icon,
                    color: .accentColor,
                    size: font.value * 1.1,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
                .frame(width: font.value * 1.2, height: font.value * 1.2)
            }
            
            VStack(alignment: .leading) {
                if let text = text {
                    RefdsText(
                        text,
                        style: font,
                        lineLimit: 1
                    )
                }
                
                if let description = description {
                    RefdsText(
                        description,
                        style: font,
                        color: .secondary,
                        lineLimit: 1
                    )
                }
            }
            
            Spacer()
            
            if let detail = detail {
                RefdsText(
                    detail,
                    style: font,
                    color: .secondary,
                    lineLimit: 1
                )
            }
            
            Menu { content() } label: {
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
