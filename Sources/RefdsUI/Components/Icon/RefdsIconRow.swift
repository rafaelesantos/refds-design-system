import SwiftUI
import RefdsShared

public struct RefdsIconRow: View {
    private let symbol: RefdsIconSymbol
    private let color: Color
    
    public init(
        _ symbol: RefdsIconSymbol,
        color: Color = .accentColor
    ) {
        self.symbol = symbol
        self.color = color
    }
    
    public var body: some View {
        RefdsIcon(
            symbol,
            color: color,
            size: 16
        )
        .frame(width: 33, height: 33)
        .background(color.opacity(0.2))
        .clipShape(.rect(cornerRadius: 8))
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(.random)
            RefdsText(.someWord())
            Spacer(minLength: .zero)
            RefdsText(.someWord(from: .cyberpunkDystopia), color: .secondary)
        }
    }
}
