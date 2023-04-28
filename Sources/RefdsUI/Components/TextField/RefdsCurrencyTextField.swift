//
//  RefdsCurrencyTextField.swift
//  
//
//  Created by Rafael Santos on 27/04/23.
//

import SwiftUI

public struct RefdsCurrencyTextField: View {
    class NumbersOnly: ObservableObject {
        @Published var value: String = "" {
            didSet {
                let filtered = value.replacingOccurrences(of: ",", with: ".").filter { $0.isNumber }
                if value != filtered, let valueDouble = Double(filtered) {
                    value = filtered
                    appearText = (valueDouble / 100).formatted(.currency(code: "BRL"))
                } else if let valueDouble = Double(value.replacingOccurrences(of: ",", with: ".")) {
                    appearText = (valueDouble / 100).formatted(.currency(code: "BRL"))
                }
                
                if value.isEmpty {
                    appearText = 0.formatted(.currency(code: "BRL"))
                }
            }
        }
        @Published var appearText: String = ""
        init(value: String = "") {
            self.value = value
        }
    }
    
    @Environment(\.sizeCategory) var sizeCategory
    @Binding private var value: Double
    @State private var appearText: String = ""
    @ObservedObject private var input = NumbersOnly()
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
        _input = ObservedObject(initialValue: NumbersOnly(value: value.wrappedValue.formatted(.currency(code: "BRL"))))
    }
    
    public var body: some View {
        ZStack {
            RefdsText(
                input.appearText,
                size: size,
                color: value == 0 ? .secondary : color,
                weight: weight,
                family: .moderatMono,
                alignment: alignment
            )
            TextField("", text: Binding(get: {
                input.value
            }, set: {
                input.value = $0
                guard let double = Double(input.value) else { return }
                value = double
            }))
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
                .keyboardType(.numbersAndPunctuation)
    #endif
        }
    }
}

struct RefdsCurrencyTextField_Previews: PreviewProvider {
    @State static var value = 0.0
    static var previews: some View {
        Group {
            RefdsCurrencyTextField(value: $value)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
    }
}
