import SwiftUI
import RefdsShared

public struct RefdsIcon: View {
    @State private var animationsRunning = false
    
    private let symbol: RefdsIconSymbol
    private let color: Color
    private let size: CGFloat?
    private let style: Font?
    private let weight: Font.Weight
    private let renderingMode: SymbolRenderingMode
    
    public init(
        _ symbol: RefdsIconSymbol,
        color: Color = .accentColor,
        size: CGFloat? = nil,
        style: Font? = .body,
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
                $0.font($1).fontWeight(weight)
            }
            .symbolRenderingMode(renderingMode)
            .foregroundColor(color)
            .onAppear { animationsRunning.toggle() }
            .contentTransition(.symbolEffect(.replace))
    }
}

#Preview {
    HStack {
        RefdsIcon(.airplaneArrival, style: .largeTitle, weight: .bold)
    }
    .padding(.padding(.extraLarge))
}
