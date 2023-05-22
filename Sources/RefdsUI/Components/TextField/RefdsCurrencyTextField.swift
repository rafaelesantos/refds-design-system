//
//  RefdsCurrencyTextField.swift
//  
//
//  Created by Rafael Santos on 27/04/23.
//

import SwiftUI

public struct RefdsCurrencyTextField: View {
    class NumbersOnly: ObservableObject {
        static let shared = NumbersOnly()
        var binding: ((Double, String) -> Void)?
        
        var double: Double = 0
        var value: String = "" {
            didSet {
                let filtered = value.replacingOccurrences(of: ",", with: ".").filter { $0.isNumber }
                if value != filtered, let valueDouble = Double(filtered) {
                    Task { @MainActor in
                        value = filtered
                        double = (valueDouble / 100)
                        appearText = (valueDouble / 100).formatted(.currency(code: "BRL"))
                    }
                } else if let valueDouble = Double(value.replacingOccurrences(of: ",", with: ".")) {
                    Task { @MainActor in
                        double = (valueDouble / 100)
                        appearText = (valueDouble / 100).formatted(.currency(code: "BRL"))
                    }
                }
                
                if value.isEmpty {
                    Task { @MainActor in
                        double = 0
                        appearText = 0.formatted(.currency(code: "BRL"))
                    }
                }
                binding?(double, appearText)
            }
        }
        var appearText: String = 0.formatted(.currency(code: "BRL"))
    }
    
    @Environment(\.sizeCategory) var sizeCategory
    @Binding private var value: Double
    @State private var appearText: String = ""
    private var numberOnly = NumbersOnly.shared
    private let size: RefdsText.Size
    private let color: Color
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    private let alignment: TextAlignment
    
    public init(
        value: Binding<Double>,
        size: RefdsText.Size = .normal,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .defaultConfiguration,
        alignment: TextAlignment = .leading
    ) {
        self._value = value
        self.size = size
        self.color = color
        self.weight = weight
        self.family = family
        self.alignment = alignment
    }
    
    public var body: some View {
        ZStack {
            RefdsText(
                numberOnly.appearText,
                size: size,
                color: value == 0 ? .secondary : color,
                weight: weight,
                family: .moderatMono,
                alignment: alignment,
                lineLimit: 1
            )
            TextField("", text: Binding(get: { numberOnly.value }, set: { numberOnly.value = $0 }))
                .refdsFont(
                    size: size,
                    weight: weight,
                    family: .moderatMono,
                    sizeCategory: sizeCategory
                )
                .multilineTextAlignment(alignment)
                .foregroundColor(.clear)
                .tint(.clear)
                .autocorrectionDisabled()
    #if os(iOS)
                .keyboardType(.numberPad)
    #endif
        }
        .onAppear {
            numberOnly.value = "\(value * 100)"
            numberOnly.binding = { value, appearText in
                self.value = value
                self.appearText = appearText
            }
        }
    }
}

struct RefdsCurrencyTextField_Previews: PreviewProvider {
    @State static var value = 10.2
    static var previews: some View {
        Group {
            RefdsCurrencyTextField(value: $value)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
    }
}
