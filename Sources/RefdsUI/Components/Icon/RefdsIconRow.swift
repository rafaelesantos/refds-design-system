import SwiftUI
import RefdsShared

public struct RefdsIconRow: View {
    private let symbol: RefdsIconSymbol
    
    public init(symbol: RefdsIconSymbol) {
        self.symbol = symbol
    }
    
    public var body: some View {
        RefdsIcon(symbol, color: .white, size: 16)
            .frame(width: 30, height: 30)
            .background(Color.accentColor)
            .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    RefdsIconRow(symbol: .random)
}
