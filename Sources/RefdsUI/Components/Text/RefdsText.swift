import SwiftUI

public struct RefdsText: View {
    private let content: String
    private let style: Font
    private let color: Color
    private let weight: Font.Weight
    private let design: Font.Design
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    public init (
        _ content: String,
        style: Font = .body,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.style = style
        self.color = color
        self.weight = weight
        self.design = design
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
    
    public var body: some View {
        Text(content)
            .font(style)
            .fontDesign(design)
            .fontWeight(weight)
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .foregroundStyle(color)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: .padding(.medium)) {
        RefdsText(.someWord(), style: .title, color: .orange, weight: .heavy, design: .serif)
        RefdsText(.someParagraph(), design: .serif)
        Divider()
        let hex = "#195AB4"
        let color = Color(hex: hex)
        RefdsText(color.asHex, style: .title, color: color, weight: .heavy, design: .serif)
        
    }
    .padding(.padding(.large))
}
