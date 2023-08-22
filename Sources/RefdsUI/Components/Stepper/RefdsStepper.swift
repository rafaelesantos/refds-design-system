import SwiftUI

public struct RefdsStepper<Value: Numeric>: View {
    @Environment(\.colorScheme) private var colorScheme
    private let byValue: Value
    private let min: Value
    private let max: Value
    private let color: RefdsColor
    private let style: Style
    @Binding private var current: Value
    
    public init(_ style: Style = .card, current: Binding<Value>, byValue: Value = 1, min: Value, max: Value, color: RefdsColor = .accentColor) {
        self.byValue = byValue
        self.min = min
        self.max = max
        self.color = color
        self.style = style
        self._current = current
    }
    
    public var body: some View {
        switch style {
        case .inline:
            inline
        case .card:
            inline
                .padding()
                .background(RefdsColor.secondaryBackground(scheme: colorScheme))
                .cornerRadius(10)
        }
    }
    
    private var inline: some View {
        HStack(spacing: 20) {
            minusButton
            RefdsText("\(current)")
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
                symbol: .minusCircleFill,
                color: color,
                size: 20,
                weight: .bold,
                renderingMode: .hierarchical
            )
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
                symbol: .plusCircleFill,
                color: color,
                size: 20,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
        .disabled(current.magnitude == max.magnitude)
    }
    
    private var width: CGFloat? {
        current.magnitude < 1000 ? 30 : nil
    }
}

public extension RefdsStepper {
    enum Style {
        case card
        case inline
    }
}

struct RefdsStepper_Previews: PreviewProvider {
    @State static var value: Int = 5
    static var previews: some View {
        List {
            Section(content: {}, footer: {
                RefdsStepper(current: .init(get: {
                    value
                }, set: {
                    value = $0
                }), min: 1, max: 10)
            })
        }
    }
}
