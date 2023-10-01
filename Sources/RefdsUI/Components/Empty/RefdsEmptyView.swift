import SwiftUI

public struct RefdsEmptyView: View {
    private let icon: RefdsIconSymbol?
    private let color: RefdsColor
    private let title: String?
    private let description: String?
    private let titleAction: String?
    private let action: (() -> Void)?
    
    public init(
        icon: RefdsIconSymbol? = nil,
        color: RefdsColor = .accentColor,
        title: String?,
        description: String? = nil,
        titleAction: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.color = color
        self.title = title
        self.description = description
        self.titleAction = titleAction
        self.action = action
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                if let icon = icon {
                    RefdsIcon(
                        symbol: icon,
                        color: color,
                        size: 30,
                        weight: .medium,
                        renderingMode: .hierarchical
                    )
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)
                }
                
                if let title = title {
                    RefdsText(
                        title,
                        style: .title3,
                        weight: .bold,
                        alignment: .leading
                    )
                }
                
                Spacer()
            }
            
            if let description = description {
                RefdsText(
                    description,
                    style: .body,
                    color: .secondary,
                    alignment: .leading
                )
            }
            
            if let action = action, let titleAction = titleAction {
                RefdsButton(
                    titleAction,
                    color: color,
                    style: .primary,
                    font: .body,
                    maxSize: true,
                    action: action
                )
                .padding(.top, 10)
            }
        }
        .padding()
    }
}

struct RefdsEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        RefdsEmptyView(
            icon: .random,
            color: .random,
            title: .randomWord,
            description: .randomParagraph,
            titleAction: .randomWord,
            action: { }
        )
        .refdsCard()
        .padding()
    }
}
