//
//  SwiftUIView.swift
//  
//
//  Created by Rafael Santos on 17/12/22.
//

import SwiftUI

public struct RefdsText: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    let content: String
    let size: Size
    let color: Color
    let weight: Font.Weight
    let family: RefdsFontFamily
    let alignment: TextAlignment
    let lineLimit: Int?
    
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
        size: Size = .extraLarge,
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
        RefdsText("Plain text with defaul configuration Plain text with defaul configuration Plain text with defaul configuration", size: .normal, weight: .bold, family: .moderatMono, alignment: .trailing, lineLimit: 2)
            .padding()
    }
}
