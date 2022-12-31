import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    typealias UIViewType = CurrencyUITextField
    
    private var numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    
    init(numberFormatter: NumberFormatter = NumberFormatter(), value: Binding<Double>) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.locale = Locale.current
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}
