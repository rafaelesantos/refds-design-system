import SwiftUI

public struct RefdsTag: View {
    private let content: String
    private let icon: RefdsIconSymbol?
    private let style: Font.TextStyle
    private let color: Color
    private let weight: Font.Weight
    private let design: Font.Design
    private let lineLimit: Int?
    
    public init(
        _ content: String,
        icon: RefdsIconSymbol? = nil,
        style: Font.TextStyle = .caption2,
        weight: Font.Weight = .bold,
        color: Color,
        design: Font.Design = .default,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.icon = icon
        self.style = style
        self.weight = weight
        self.color = color
        self.design = design
        self.lineLimit = lineLimit
    }

    public var body: some View {
        HStack {
            if let symbol = icon {
                RefdsIcon(
                    symbol,
                    color: color,
                    weight: weight,
                    renderingMode: .monochrome
                )
            }
            RefdsText(
                content,
                style: style,
                color: color,
                weight: weight,
                design: design,
                lineLimit: lineLimit
            )
        }
        .padding(.padding(.extraSmall))
        .background(color.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

#Preview {
    VStack {
        RefdsTag("tag here", color: .blue)
        RefdsTag("tag here tag here tag here tag here tag here", color: .orange)
        RefdsTag("tag here", style: .footnote, color: .green)
        RefdsTag("timer", icon: .clock, style: .footnote, color: .pink)
    }
    .padding()
}
