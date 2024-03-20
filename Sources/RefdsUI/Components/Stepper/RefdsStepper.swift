import SwiftUI

public struct RefdsStepper<Value: Numeric>: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var current: Value
    
    private let byValue: Value
    private let min: Value
    private let max: Value
    private let color: RefdsColor
    private let style: Font.TextStyle
    
    public init(
        _ current: Binding<Value>,
        byValue: Value = 1,
        min: Value,
        max: Value,
        color: RefdsColor = .accentColor,
        style: Font.TextStyle = .body
    ) {
        self._current = current
        self.byValue = byValue
        self.min = min
        self.max = max
        self.color = color
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: .padding(.medium)) {
            minusButton
            RefdsText("\(current)", style: style)
                .frame(width: width)
            plusButton
        }
    }
    
    private var minusButton: some View {
        RefdsButton {
            if current.magnitude - byValue.magnitude >= min.magnitude {
                current -= byValue
            }
        } label: {
            RefdsIcon(
                .minusCircleFill,
                color: color,
                style: style,
                weight: .bold,
                renderingMode: .hierarchical
            )
            .scaleEffect(1.3)
        }
        .disabled(current.magnitude == min.magnitude)
    }
    
    private var plusButton: some View {
        RefdsButton {
            if current.magnitude + byValue.magnitude <= max.magnitude {
                current += byValue
            }
        } label: {
            RefdsIcon(
                .plusCircleFill,
                color: color,
                style: style,
                weight: .bold,
                renderingMode: .hierarchical
            )
            .scaleEffect(1.3)
        }
        .disabled(current.magnitude == max.magnitude)
    }
    
    private var width: CGFloat? {
        current.magnitude < 1000 ? 30 : nil
    }
}

#Preview {
    RefdsStepper(.constant(5), min: 1, max: 10)
        .padding()
}
