import SwiftUI

public struct RefdsIcon: View {
    private let symbol: RefdsIconSymbol
    private let color: RefdsColor
    private let size: CGFloat?
    private let style: Font.TextStyle?
    private let weight: Font.Weight
    private let renderingMode: SymbolRenderingMode
    
    public init(
        _ symbol: RefdsIconSymbol,
        color: RefdsColor = .accentColor,
        size: CGFloat? = nil,
        style: Font.TextStyle? = .body,
        weight: Font.Weight = .regular,
        renderingMode: SymbolRenderingMode = .monochrome
    ) {
        self.symbol = symbol
        self.color = color
        self.size = size
        self.style = style
        self.weight = weight
        self.renderingMode = renderingMode
    }
    
    
    public var body: some View {
        Image(systemName: symbol.rawValue)
            .if(size) {
                $0.font(.system(size: $1, weight: weight))
            }
            .if(style) {
                $0.font(.system($1, weight: weight))
            }
            .symbolRenderingMode(renderingMode)
            .foregroundColor(color)
    }
}

#Preview {
    HStack {
        RefdsIcon(.infinity)
        RefdsIcon(.infinity, color: .green)
        RefdsIcon(.infinity, color: .red, size: 20)
        RefdsIcon(.infinity, color: .orange, style: .largeTitle)
        RefdsIcon(.infinity, color: .mint, weight: .black)
        RefdsIcon(.paintpalette, renderingMode: .multicolor)
    }
    .padding()
}
