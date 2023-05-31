//
//  RefdsTag.swift
//  
//
//  Created by Rafael Santos on 18/12/22.
//

import SwiftUI

public struct RefdsTag: View {
    private let content: String
    private let style: RefdsText.Style
    private let color: Color
    private let family: RefdsFontFamily
    private let lineLimit: Int?

    public var body: some View {
        RefdsText(
            content.uppercased(),
            style: style,
            color: color,
            weight: .bold,
            family: family,
            lineLimit: lineLimit
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(color.opacity(0.2))
        .cornerRadius(6)
    }
}

extension RefdsTag {
    public init(
        _ content: String,
        style: RefdsText.Style = .caption2,
        color: Color,
        family: RefdsFontFamily = .defaultConfiguration,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.style = style
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
        }
    }
}
