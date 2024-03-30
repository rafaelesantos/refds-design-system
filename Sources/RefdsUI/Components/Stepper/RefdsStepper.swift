import SwiftUI

public struct RefdsStepper<Value: Numeric>: View {
    @Binding private var current: Value
    
    private let byValue: Value
    private let min: Value
    private let max: Value
    private let color: RefdsColor
    private let style: Font.TextStyle
    private let content: (() -> any View)?
    
    public init(
        _ current: Binding<Value>,
        byValue: Value = 1,
        min: Value,
        max: Value,
        color: RefdsColor = .accentColor,
        style: Font.TextStyle = .body,
        content: (() -> any View)? = nil
    ) {
        self._current = current
        self.byValue = byValue
        self.min = min
        self.max = max
        self.color = color
        self.style = style
        self.content = content
    }
    
    public var body: some View {
        HStack(spacing: .padding(.medium)) {
            if let content = content {
                AnyView(
                    content()
                        .animation(.default, value: current)
                        .contentTransition(.numericText())
                )
                Spacer()
            }
            
            HStack(spacing: .padding(.medium)) {
                minusButton
                Divider().frame(height: 20)
                plusButton
            }
        }
    }
    
    private var canMinus: Bool {
        current.magnitude - byValue.magnitude >= min.magnitude
    }
    
    private var canSum: Bool {
        current.magnitude + byValue.magnitude <= max.magnitude
    }
    
    private var minusButton: some View {
        RefdsButton {
            if canMinus { current -= byValue }
        } label: {
            RefdsIcon(
                .minus,
                color: canMinus ? color : .placeholder,
                style: .caption2,
                weight: .bold,
                renderingMode: .hierarchical
            )
            .frame(
                width: .padding(.extraLarge),
                height: .padding(.extraLarge)
            )
            .background((canMinus ? color : .placeholder).opacity(0.2))
            .clipShape(.circle)
        }
        .disabled(current.magnitude == min.magnitude)
    }
    
    private var plusButton: some View {
        RefdsButton {
            if canSum { current += byValue }
        } label: {
            RefdsIcon(
                .plus,
                color: canSum ? color : .placeholder,
                style: .caption2,
                weight: .bold,
                renderingMode: .hierarchical
            )
            .frame(
                width: .padding(.extraLarge),
                height: .padding(.extraLarge)
            )
            .background((canSum ? color : .placeholder).opacity(0.2))
            .clipShape(.circle)
        }
        .disabled(current.magnitude == max.magnitude)
    }
}

#Preview {
    struct ContainerView: View {
        @State private var value: Double = 50
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsStepper($value, byValue: 5, min: 1, max: 100) {
                    RefdsText(value.currency(), style: .title, weight: .bold, design: .monospaced)
                }
            }
            .padding(.padding(.large))
        }
    }
    return ContainerView()
}
