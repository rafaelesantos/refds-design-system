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
    private let style: Style
    private let color: Color
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    public var body: some View {
        Text(content)
            .refdsFont(
                style: style,
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
        style: Style = .body,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .defaultConfiguration,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.style = style
        self.color = color
        self.weight = weight
        self.family = family
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
}

extension View {
    public func refdsFont(
        style: RefdsText.Style = .body,
        weight: Font.Weight = .regular,
        family: RefdsFontFamily = .defaultConfiguration,
        sizeCategory: ContentSizeCategory
    ) -> some View {
        return self.font(
            .refds(
                size: style.value,
                scaledSize: sizeCategory.ratio * style.value,
                family: family,
                weight: weight,
                style: style.textStyle
            )
        )
    }
}

public extension View {
    @ViewBuilder
    func refdsSkeleton(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}

extension String {
    static func placeholder(length: Int = .random(in: 5 ... 100)) -> String {
        String(Array(repeating: "X", count: length))
    }
}

struct RefdsText_Previews: PreviewProvider {
    @State static var content: String = ""
    static var previews: some View {
        GroupBox {
            RefdsText(content, style: .body, weight: .bold, family: .moderat, alignment: .trailing, lineLimit: 2)
        }
        .padding()
        .previewDisplayName("Default")
        .previewLayout(.sizeThatFits)
        
        GroupBox {
            RefdsText("Plain text with defaul configuration Plain text with defaul configuration Plain text with defaul configuration", style: .body, color: .orange, weight: .bold, family: .moderat, alignment: .center)
        }
        .padding()
        .previewDisplayName("Customization")
        .previewLayout(.sizeThatFits)
    }
}
