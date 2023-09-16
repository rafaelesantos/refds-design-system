import SwiftUI

public struct RefdsEmptyView: View {
    private let icon: RefdsIconSymbol
    private let color: RefdsColor
    private let title: String
    private let description: String
    
    public init(icon: RefdsIconSymbol, color: RefdsColor, title: String, description: String) {
        self.icon = icon
        self.color = color
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 25) {
            RefdsIcon(symbol: icon, color: color, size: 80, weight: .medium, renderingMode: .hierarchical)
            VStack(alignment: .center, spacing: 5) {
                RefdsText(title, style: .body, weight: .bold, alignment: .center)
                RefdsText(description, style: .subheadline, color: .secondary, alignment: .center)
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
