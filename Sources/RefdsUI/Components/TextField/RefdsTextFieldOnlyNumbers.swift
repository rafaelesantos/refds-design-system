import SwiftUI

protocol RefdsTextFieldOnlyNumbersDelegate {
    func updateValue(_ value: Double)
}

class RefdsTextFieldOnlyNumbers: ObservableObject {
    @Published var appearText: String
    @Published var value: String = "" { didSet { handlerValue() } }
    var delegate: RefdsTextFieldOnlyNumbersDelegate?
    
    init(value: Double) {
        let doubleValue = value * 10
        appearText = doubleValue.currency()
        self.value = "\(doubleValue)"
    }
    
    private func handlerValue() {
        let filtered = value
            .replacingOccurrences(of: ",", with: ".")
            .filter { $0.isNumber }
        
        if value != filtered,
           let valueDouble = Double(filtered) {
            Task { @MainActor in
                value = filtered
                delegate?.updateValue(valueDouble / 100)
                appearText = (valueDouble / 100).currency()
            }
        } else if let valueDouble = Double(value.replacingOccurrences(of: ",", with: ".")) {
            Task { @MainActor in
                delegate?.updateValue(valueDouble / 100)
                appearText = (valueDouble / 100).currency()
            }
        }
        
        if value.isEmpty {
            Task { @MainActor in
                delegate?.updateValue(.zero)
                appearText = Double.zero.currency()
            }
        }
    }
}
