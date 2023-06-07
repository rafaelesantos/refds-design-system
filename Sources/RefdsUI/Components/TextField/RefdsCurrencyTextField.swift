//
//  RefdsCurrencyTextField.swift
//
//
//  Created by Rafael Santos on 27/04/23.
//

import SwiftUI

public struct RefdsCurrencyTextField: View {
    class NumbersOnly: ObservableObject {
        @Binding var double: Double { didSet {  } }
        @Published var value: String = "" {
            didSet {
                let filtered = value.replacingOccurrences(of: ",", with: ".").filter { $0.isNumber }
                if value != filtered, let valueDouble = Double(filtered) {
                    Task { @MainActor in
                        value = filtered
                        double = (valueDouble / 100)
                        appearText = (valueDouble / 100).currency
                    }
                } else if let valueDouble = Double(value.replacingOccurrences(of: ",", with: ".")) {
                    Task { @MainActor in
                        double = (valueDouble / 100)
                        appearText = (valueDouble / 100).currency
                    }
                }
                
                if value.isEmpty {
                    Task { @MainActor in
                        double = 0
                        appearText = 0.currency
                    }
                }
            }
        }
        @Published var appearText: String
        init(double: Binding<Double>) {
            let doubleValue = double.wrappedValue * 10
            self._double = double
            appearText = doubleValue.currency
            value = "\(doubleValue)"
        }
    }
    
    @Environment(\.sizeCategory) var sizeCategory
    @Binding private var value: Double
    @State private var appearText: String = ""
    @StateObject private var input: NumbersOnly
    private let style: RefdsText.Style
    private let color: Color
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    private let alignment: TextAlignment
    
    public init(
        value: Binding<Double>,
        style: RefdsText.Style = .body,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .defaultConfiguration,
        alignment: TextAlignment = .leading
    ) {
        self._value = value
        self.style = style
        self.color = color
        self.weight = weight
        self.family = family
        self.alignment = alignment
        _input = StateObject(wrappedValue: NumbersOnly(double: value))
    }
    
    public var body: some View {
        ZStack {
            RefdsText(
                input.appearText,
                style: style,
                color: value == 0 ? .secondary : color,
                weight: weight,
                family: family,
                alignment: alignment,
                lineLimit: 1
            )
            TextField("", text: $input.value)
                .refdsFont(
                    style: style,
                    weight: weight,
                    family: family,
                    sizeCategory: sizeCategory
                )
                .multilineTextAlignment(alignment)
                .foregroundColor(.clear)
                .tint(.clear)
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
    #if os(iOS)
                .keyboardType(.numberPad)
    #endif
        }
    }
}

struct RefdsCurrencyTextField_Previews: PreviewProvider {
    @State static var value = 50.2
    static var previews: some View {
        Group {
            RefdsCurrencyTextField(value: $value)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
    }
}
