//
//  SwiftUIView.swift
//  
//
//  Created by Rafael Santos on 17/12/22.
//

import SwiftUI

public struct RefdsText: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    private let content: String
    private let size: Size
    private let color: Color
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    public var body: some View {
        Text(content)
            .refdsFont(
                size: size,
                weight: weight,
                family: family,
                sizeCategory: sizeCategory
            )
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .foregroundColor(color)
    }
}

extension RefdsText {
    public init (
        _ content: String,
        size: Size = .normal,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .moderat,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.size = size
        self.color = color
        self.weight = weight
        self.family = family
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
}

extension Text {
    public func refdsFont(
        size: RefdsText.Size = .normal,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .moderat,
        sizeCategory: ContentSizeCategory
    ) -> Self {
        return self.font(
            .refds(
                size: size.value,
                scaledSize: sizeCategory.ratio * size.value,
                family: family,
                weight: weight,
                style: size.textStyle
            )
        )
    }
}

struct RefdsText_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            RefdsText("Plain text with defaul configuration Plain text with defaul configuration Plain text with defaul configuration", size: .normal, weight: .bold, family: .moderatMono, alignment: .trailing, lineLimit: 2)
        }
        .padding()
        .previewDisplayName("Defaul")
        .previewLayout(.sizeThatFits)
        
        GroupBox {
            RefdsText("Plain text with defaul configuration Plain text with defaul configuration Plain text with defaul configuration", size: .normal, color: .orange, weight: .bold, family: .moderat, alignment: .center)
        }
        .padding()
        .previewDisplayName("Customization")
        .previewLayout(.sizeThatFits)
    }
}
