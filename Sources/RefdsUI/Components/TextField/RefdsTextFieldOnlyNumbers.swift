import SwiftUI

class RefdsTextFieldOnlyNumbers: ObservableObject {
    @Binding var double: Double
    @Published var appearText: String
    @Published var value: String = "" {
        didSet { handlerValue() }
    }
    
    init(double: Binding<Double>) {
        let doubleValue = double.wrappedValue * 10
        self._double = double
        appearText = doubleValue.currency()
        value = "\(doubleValue)"
    }
    
    private func handlerValue() {
        let filtered = value
            .replacingOccurrences(of: ",", with: ".")
            .filter { $0.isNumber }
        
        if value != filtered,
           let valueDouble = Double(filtered) {
            Task { @MainActor in
                value = filtered
                double = (valueDouble / 100)
                appearText = (valueDouble / 100).currency()
            }
        } else if let valueDouble = Double(value.replacingOccurrences(of: ",", with: ".")) {
            Task { @MainActor in
                double = (valueDouble / 100)
                appearText = (valueDouble / 100).currency()
            }
        }
        
        if value.isEmpty {
            Task { @MainActor in
                double = 0
                appearText = 0.currency()
            }
        }
    }
}
