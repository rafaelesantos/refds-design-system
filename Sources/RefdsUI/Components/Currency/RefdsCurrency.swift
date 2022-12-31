import SwiftUI

public struct RefdsCurrency: View {
    @Binding private var value: Double
    
    public init(value: Binding<Double>) {
        self._value = value
    }
    
    public var body: some View {
        CurrencyTextField(value: $value)
            .frame(height: 50)
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
