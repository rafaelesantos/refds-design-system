import SwiftUI

public struct RefdsCurrency: View {
    @Binding private var value: Double
    private let color: Color
    private let style: RefdsCurrency.Style
    private let alignment: NSTextAlignment
    
    public init(
        value: Binding<Double>,
        color: Color = .secondary,
        style: RefdsCurrency.Style = .large,
        alignment: NSTextAlignment = .center
    ) {
        self._value = value
        self.color = color
        self.style = style
        self.alignment = alignment
    }
    
    public var body: some View {
        CurrencyTextField(value: $value, color: color, style: style, alignment: alignment)
            .frame(height: 50)
    }
}

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

struct RefdsCurrency_Previews: PreviewProvider {
    @State static var value = 0.0
    static var previews: some View {
        GroupBox {
            RefdsCurrency(value: $value)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
    }
}
