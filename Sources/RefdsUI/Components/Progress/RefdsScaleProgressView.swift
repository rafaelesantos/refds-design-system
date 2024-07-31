import SwiftUI

public struct RefdsScaleProgressView: View {
    public enum Style {
        case chart
        case circle
        case lockScreen
    }
    
    private let style: Style
    private let riskColor: Color
    private let size: CGFloat
    
    private var level: Int {
        switch riskColor {
        case .green: return 0
        case .yellow: return 1
        case .orange: return 2
        case .red: return 3
        default: return 4
        }
    }
    
    public init(
        _ style: Style = .chart,
        riskColor: Color,
        size: CGFloat = 16
    ) {
        self.style = style
        self.riskColor = riskColor
        self.size = size
    }
    
    @ViewBuilder
    public var body: some View {
        switch style {
        case .chart: chartView
        case .circle: circleView
        case .lockScreen: lockScreenView
        }
    }
    
    private var chartView: some View {
        HStack(alignment: .bottom, spacing: size * 0.1) {
            ForEach((0 ... 3).map({ $0 }), id: \.self) { level in
                RoundedRectangle(cornerRadius: size * 0.08)
                    .frame(width: size * 0.3, height: height(for: level))
                    .foregroundColor(self.level >= level ? color(for: level) : .secondary.opacity(0.1))
            }
        }
    }
    
    private var circleView: some View {
        HStack(alignment: .bottom, spacing: size * 0.1) {
            ForEach((0 ... 3).map({ $0 }), id: \.self) { level in
                Circle()
                    .frame(width: size * 0.3, height: size * 0.3)
                    .foregroundColor(self.level >= level ? color(for: level) : .secondary.opacity(0.1))
            }
        }
    }
    
    private var lockScreenView: some View {
        HStack(alignment: .bottom, spacing: size * 0.1) {
            ForEach((0 ... 3).map({ $0 }), id: \.self) { level in
                Circle()
                    .frame(width: size * 0.3, height: size * 0.3)
                    .foregroundColor(self.level >= level ? .primary : .secondary.opacity(0.1))
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
        
        HStack(spacing: .padding(.medium)) {
            RefdsScaleProgressView(.circle, riskColor: .orange)
            RefdsText(.someWord())
        }
    }
}
