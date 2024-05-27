import SwiftUI

public struct RefdsScaleProgressView: View {
    private let riskColor: Color
    private let size: CGFloat
    
    public init(
        riskColor: Color,
        size: CGFloat = 16
    ) {
        self.riskColor = riskColor
        self.size = size
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: size * 0.1) {
            ForEach((0 ... 3).map({ $0 }), id: \.self) { level in
                RoundedRectangle(cornerRadius: size * 0.08)
                    .frame(width: size * 0.3, height: height(for: level))
                    .foregroundColor(color(for: level))
            }
        }
    }
    
    func color(for level: Int) -> Color {
        switch level {
        case 0: return .green
        case 1: return .yellow
        case 2: return .orange
        case 3: return .red
        default: return .secondary.opacity(0.1)
        }
    }
    
    func height(for level: Int) -> CGFloat {
        switch level {
        case 0: return size * 0.4
        case 1: return size * 0.6
        case 2: return size * 0.8
        case 3: return size
        default: return 0
        }
    }
}

#Preview {
    List {
        HStack(spacing: .padding(.medium)) {
            RefdsScaleProgressView(riskColor: .orange)
            RefdsText(.someWord())
        }
    }
}
