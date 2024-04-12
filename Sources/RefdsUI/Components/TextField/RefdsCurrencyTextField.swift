#if os(iOS)
import UIKit
#endif
import SwiftUI

public struct RefdsCurrencyTextField: View, RefdsTextFieldOnlyNumbersDelegate {
    @State private var appearText: String = ""
    @StateObject private var input: RefdsTextFieldOnlyNumbers
    @Binding private var value: Double
    
    private let style: Font.TextStyle
    private let color: Color
    private let weight: Font.Weight
    private let design: Font.Design
    private let alignment: TextAlignment
    
    private var bindingValue: Binding<Double> {
        Binding { value } set: { value = $0 }
    }
    
    public init(
        value: Binding<Double>,
        style: Font.TextStyle = .body,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        alignment: TextAlignment = .leading
    ) {
        self._value = value
        self.style = style
        self.color = color
        self.weight = weight
        self.design = design
        self.alignment = alignment
        let input = RefdsTextFieldOnlyNumbers(value: value.wrappedValue)
        self._input = StateObject(wrappedValue: input)
    }
    
    private var textColor: Color {
        value == .zero ? .secondary : color
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            RefdsText(
                value.currency(),
                style: style,
                color: textColor,
                weight: weight,
                design: design,
                alignment: alignment,
                lineLimit: 1
            )
            .contentTransition(.numericText(value: value))
            .animation(.default, value: value)
            
            TextField("", text: $input.value)
                .font(.system(style, design: design, weight: weight))
                .multilineTextAlignment(alignment)
                .foregroundColor(.clear)
                .tint(.clear)
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
    #if os(iOS)
                .keyboardType(.numberPad)
    #endif
        }
        .onAppear { input.delegate = self }
#if os(iOS)
        .onAppear { UITextField.appearance().clearButtonMode = .never }
        .onDisappear { UITextField.appearance().clearButtonMode = .whileEditing }
#endif
    }
    
    func updateValue(_ value: Double) {
        
    }
}

#Preview {
    struct ContainerView: View {
        @State private var value: Double = 0
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsCurrencyTextField(
                    value: $value,
                    style: .largeTitle,
                    weight: .heavy,
                    design: .rounded
                )
            }
            .padding(.padding(.large))
        }
    }
    return ContainerView()
}
