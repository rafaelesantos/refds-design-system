import SwiftUI
import RefdsShared

public struct RefdsIconRow: View {
    private let symbol: RefdsIconSymbol
    private let color: Color
    private let size: CGFloat
    private let opacity: CGFloat
    
    public init(
        _ symbol: RefdsIconSymbol,
        color: Color = .accentColor,
        size: CGFloat = 33,
        opacity: CGFloat = 0.2
    ) {
        self.symbol = symbol
        self.color = color
        self.size = size
        self.opacity = opacity
    }
    
    public var body: some View {
        RefdsIcon(
            symbol,
            color: color,
            size: size / 2
        )
        .frame(width: size, height: size)
        .background(color.opacity(opacity))
        .clipShape(.rect(cornerRadius: size * 0.24))
        .padding(.vertical, size * 0.07)
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
