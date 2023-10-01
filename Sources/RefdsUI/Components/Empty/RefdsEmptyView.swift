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
        VStack(alignment: .center, spacing: 25) {
            if let icon = icon {
                RefdsIcon(
                    symbol: icon,
                    color: color,
                    size: 50,
                    weight: .medium,
                    renderingMode: .hierarchical
                )
            }
            VStack(alignment: .center, spacing: 5) {
                if let title = title {
                    RefdsText(
                        title,
                        style: .title3,
                        weight: .bold,
                        alignment: .center
                    )
                }
                
                if let description = description {
                    RefdsText(
                        description,
                        style: .body,
                        color: .secondary,
                        alignment: .center
                    )
                }
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
            }
        }
        .frame(maxWidth: 250)
    }
}

struct RefdsEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        RefdsEmptyView(
            icon: .random,
            color: .random,
            title: .randomWord,
            description: .randomParagraph
        )
    }
}
