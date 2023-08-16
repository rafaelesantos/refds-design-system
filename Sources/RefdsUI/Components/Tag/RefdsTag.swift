//
//  RefdsTag.swift
//  
//
//  Created by Rafael Santos on 18/12/22.
//

import SwiftUI

public struct RefdsTag: View {
    private let content: String
    private let icon: RefdsIconSymbol?
    private let style: RefdsText.Style
    private let color: Color
    private let weight: Font.Weight
    private let family: RefdsFontFamily
    private let lineLimit: Int?

    public var body: some View {
        HStack {
            if let symbol = icon {
                RefdsIcon(
                    symbol: symbol,
                    color: color,
                    size: style.value,
                    weight: weight,
                    renderingMode: .hierarchical
                )
            }
            RefdsText(
                content,
                style: style,
                color: color,
                weight: weight,
                family: family,
                lineLimit: lineLimit
            )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(color.opacity(0.2))
        .cornerRadius(6)
    }
}

extension RefdsTag {
    public init(
        _ content: String,
        icon: RefdsIconSymbol? = nil,
        style: RefdsText.Style = .caption2,
        weight: Font.Weight = .bold,
        color: Color,
        family: RefdsFontFamily = .defaultConfiguration,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.icon = icon
        self.style = style
        self.weight = weight
        self.color = color
        self.family = family
        self.lineLimit = lineLimit
    }
}

struct RefdsTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            RefdsTag("tag here", color: .blue)
            RefdsTag("tag here tag here tag here tag here tag here", color: .orange)
            RefdsTag("tag here", style: .footnote, color: .green)
            RefdsTag("timer", icon: .clock, style: .footnote, color: .pink)
        }
    }
}
