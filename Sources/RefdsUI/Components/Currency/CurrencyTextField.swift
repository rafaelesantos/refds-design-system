import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    typealias UIViewType = CurrencyUITextField
    
    private var numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    private let color: Color
    private let style: RefdsCurrency.Style
    private let alignment: NSTextAlignment
    
    init(
        numberFormatter: NumberFormatter = NumberFormatter(),
        value: Binding<Double>,
        color: Color = .secondary,
        style: RefdsCurrency.Style = .regular,
        alignment: NSTextAlignment = .left
    ) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.locale = Locale.current
        self.color = color
        self.style = style
        self.alignment = alignment
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value, color: UIColor(color), style: style, alignment: alignment)
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}
