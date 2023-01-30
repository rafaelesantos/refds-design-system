import SwiftUI

public struct RefdsCurrency: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Binding private var value: Double
    private let color: Color
    private let alignment: TextAlignment
    private let size: RefdsText.Size
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    
    public init(
        value: Binding<Double>,
        color: Color = .secondary,
        alignment: TextAlignment = .center,
        size: RefdsText.Size = .normal,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .moderatMono
    ) {
        self._value = value
        self.color = color
        self.alignment = alignment
        self.size = size
        self.weight = weight
        self.family = family
    }
    
    public var body: some View {
        ZStack {
            TextField(value.formatted(.currency(code: "BRL")), value: $value, format: .currency(code: "BRL"))
                .refdsFont(size: size, weight: weight, family: family, sizeCategory: sizeCategory)
                .multilineTextAlignment(alignment)
                .foregroundColor(color)
#if os(iOS)
                .keyboardType(.decimalPad)
#endif
        }
        .frame(maxWidth: .infinity)
    }
}

#if os(iOS)
extension RefdsCurrency {
    public enum Style {
        case large
        case regular
        
        var size: UIFont.Size {
            switch self {
            case .large: return .displayTitle
            case .regular: return .large
            }
        }
    }
}
#endif

struct RefdsCurrency_Previews: PreviewProvider {
    @State static var value = 0.0
    static var previews: some View {
        Group {
            RefdsCurrency(value: $value)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
    }
}
