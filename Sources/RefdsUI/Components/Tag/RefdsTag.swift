//
//  RefdsTag.swift
//  
//
//  Created by Rafael Santos on 18/12/22.
//

import SwiftUI

public struct RefdsTag: View {
    private let content: String
    private let size: RefdsText.Size
    private let color: Color
    private let family: RefdsFontFamily
    private let lineLimit: Int?

    public var body: some View {
        RefdsText(
            content.uppercased(),
            size: size,
            color: color,
            weight: .bold,
            family: family,
            lineLimit: lineLimit
        )
        .padding(6)
        .background(color.opacity(0.2))
        .cornerRadius(6)
    }
}

extension RefdsTag {
    public init(
        _ content: String,
        size: RefdsText.Size = .extraSmall,
        color: Color,
        family: RefdsFontFamily = RefdsUI.shared.defaultFontFamily,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.size = size
        self.color = color
        self.family = family
        self.lineLimit = lineLimit
    }
}

struct RefdsTag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RefdsTag("tag here", color: .blue)
            RefdsTag("tag here tag here tag here tag here tag here", color: .orange)
        }
    }
}
