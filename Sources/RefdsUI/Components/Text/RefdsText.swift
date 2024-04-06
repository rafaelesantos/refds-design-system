import SwiftUI

public struct RefdsText: View {
    private let content: String
    private let style: Font.TextStyle
    private let color: Color
    private let weight: Font.Weight
    private let design: Font.Design
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    public init (
        _ content: String,
        style: Font.TextStyle = .body,
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
            .font(.system(style, design: design, weight: weight))
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .foregroundColor(color)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: .padding(.medium)) {
        RefdsText(.someWord(), style: .title, color: .orange, weight: .heavy, design: .serif)
        
        RefdsText(.someParagraph(), design: .serif)
    }
    .padding(.padding(.large))
}
