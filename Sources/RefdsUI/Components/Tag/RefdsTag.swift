import SwiftUI
import RefdsShared

public struct RefdsTag: View {
    private let content: String
    private let icon: RefdsIconSymbol?
    private let style: Font
    private let color: Color
    private let weight: Font.Weight
    private let design: Font.Design
    private let lineLimit: Int?
    
    public init(
        _ content: String,
        icon: RefdsIconSymbol? = nil,
        style: Font = .footnote,
        weight: Font.Weight = .bold,
        color: Color = .primary,
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
    
    private var isPrimary: Bool { color == .primary }

    public var body: some View {
        HStack(spacing: .padding(.extraSmall)) {
            if let symbol = icon {
                RefdsIcon(
                    symbol,
                    color: color ,
                    weight: weight,
                    renderingMode: isPrimary ? .multicolor : .monochrome
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
        .if(!isPrimary) { $0.padding(.padding(.small)) }
        .background(isPrimary ? nil : color.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
        .if(isPrimary) { $0.refdsBorder(padding: .small) }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: .padding(.medium)) {
        RefdsTag(.someWord(), color: .blue)
        RefdsTag(.someParagraph(), color: .orange)
        RefdsTag(.someWord(), style: .title, color: .green)
        RefdsTag(.someWord(), icon: .clock)
    }
    .padding(.padding(.large))
}
