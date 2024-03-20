import SwiftUI

public struct RefdsCurrency: View {
    @Binding private var value: Double
    private let color: Color
    private let alignment: TextAlignment
    private let style: Font.TextStyle
    private let weight: Font.Weight
    private let design: Font.Design
    
    public init(
        value: Binding<Double>,
        color: Color = .secondary,
        alignment: TextAlignment = .center,
        style: Font.TextStyle = .body,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) {
        self._value = value
        self.color = color
        self.alignment = alignment
        self.style = style
        self.weight = weight
        self.design = design
    }
    
    public var body: some View {
        ZStack {
            TextField(value.currency(), value: $value, format: .currency(code: Locale.current.identifier))
                .font(.system(style, design: design, weight: weight))
                .multilineTextAlignment(alignment)
                .foregroundColor(color)
                #if os(iOS)
                .keyboardType(.decimalPad)
                #endif
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Group {
        RefdsCurrency(value: .constant(23))
    }
    .padding()
}
