#if os(iOS)
import UIKit
#endif
import SwiftUI

public struct RefdsCurrencyTextField: View {
    @State private var appearText: String = ""
    @State private var valueText: String = ""
    @Binding private var value: Double
    
    private let style: Font.TextStyle
    private let color: Color
    private let weight: Font.Weight
    private let design: Font.Design
    private let alignment: TextAlignment
    
    public init(
        value: Binding<Double>,
        style: Font.TextStyle = .body,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        alignment: TextAlignment = .center
    ) {
        self._value = value
        self.style = style
        self.color = color
        self.weight = weight
        self.design = design
        self.alignment = alignment
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
            .frame(maxWidth: .infinity)
            
            TextField("", text: $valueText)
                .font(.system(style, design: design, weight: weight))
                .multilineTextAlignment(alignment)
                .foregroundColor(.clear)
                .tint(.clear)
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
                .background(.clear)
                .opacity(0.1)
                .frame(maxWidth: .infinity)
    #if os(iOS)
                .keyboardType(.numberPad)
    #endif
        }
        .onAppear { valueText = (value * 10).asString }
        .onChange(of: valueText) { handlerValue() }
#if os(iOS)
        .onAppear { UITextField.appearance().clearButtonMode = .never }
        .onDisappear { UITextField.appearance().clearButtonMode = .whileEditing }
#endif
    }
    
    private func handlerValue() {
        let filtered = valueText
            .replacingOccurrences(of: ",", with: ".")
            .filter { $0.isNumber }
        
        if valueText != filtered,
           let valueDouble = Double(filtered) {
            valueText = filtered
            value = valueDouble / 100
            appearText = (valueDouble / 100).currency()
        } else if let valueDouble = Double(valueText.replacingOccurrences(of: ",", with: ".")) {
            value = valueDouble / 100
            appearText = (valueDouble / 100).currency()
        }
        
        if valueText.isEmpty {
            value = .zero
            appearText = Double.zero.currency()
        }
    }
}

#Preview {
    struct ContainerView: View {
        @State private var value: Double = 15
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
