//
//  RefdsTextField.swift
//  
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI

public struct RefdsTextField: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Binding private var text: String
    private let placeholder: String
    private let axis: Axis
    private let size: RefdsText.Size
    private let color: Color
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    private let alignment: TextAlignment
    private let minimumScaleFactor: CGFloat
    private let lineLimit: Int?
    #if os(iOS)
    private let keyboardType: UIKeyboardType
    private let textInputAutocapitalization: TextInputAutocapitalization
    #endif
    
    #if os(iOS)
    public init(
        _ placeholder: String,
        text: Binding<String>,
        axis: Axis = .horizontal,
        size: RefdsText.Size = .normal,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .defaultConfiguration,
        alignment: TextAlignment = .leading,
        minimumScaleFactor: CGFloat = 1,
        lineLimit: Int? = nil,
        keyboardType: UIKeyboardType = .default,
        textInputAutocapitalization: TextInputAutocapitalization = .never
    ) {
        self._text = text
        self.placeholder = placeholder
        self.axis = axis
        self.size = size
        self.color = color
        self.weight = weight
        self.family = family
        self.alignment = alignment
        self.minimumScaleFactor = minimumScaleFactor
        self.lineLimit = lineLimit
        self.keyboardType = keyboardType
        self.textInputAutocapitalization = textInputAutocapitalization
    }
    #endif
    
    public init(
        _ placeholder: String,
        text: Binding<String>,
        axis: Axis = .horizontal,
        size: RefdsText.Size = .normal,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .defaultConfiguration,
        alignment: TextAlignment = .leading,
        minimumScaleFactor: CGFloat = 1,
        lineLimit: Int? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.axis = axis
        self.size = size
        self.color = color
        self.weight = weight
        self.family = family
        self.alignment = alignment
        self.minimumScaleFactor = minimumScaleFactor
        self.lineLimit = lineLimit
        #if os(iOS)
        self.keyboardType = .default
        self.textInputAutocapitalization = .never
        #endif
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .refdsFont(
                size: size,
                weight: weight,
                family: Double(text) == nil ? family : .moderatMono,
                sizeCategory: sizeCategory
            )
            .multilineTextAlignment(alignment)
            .autocorrectionDisabled()
            .foregroundColor(color)
            .minimumScaleFactor(minimumScaleFactor)
            .lineLimit(lineLimit)
        #if os(iOS)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(textInputAutocapitalization)
        #endif
    }
}

struct RefdsTextField_Previews: PreviewProvider {
    @State static var value = ""
    static var previews: some View {
        Group {
            RefdsTextField("Informe o texto", text: $value)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
    }
}
