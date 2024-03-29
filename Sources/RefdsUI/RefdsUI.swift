import SwiftUI

public class RefdsUI {
    public static let shared = RefdsUI()
    
    public var accentColor: RefdsColor
    public var cornerRadius: CGFloat
    public var colorScheme: ColorScheme?
    public var padding: RefdsPadding
    public var lineWidth: CGFloat
    public var fontDesign: Font.Design
    
    public init(
        accentColor: RefdsColor = .green,
        cornerRadius: CGFloat = 10,
        colorScheme: ColorScheme? = nil,
        padding: RefdsPadding = .default,
        lineWidth: CGFloat = 1,
        fontDesign: Font.Design = .default
    ) {
        self.accentColor = accentColor
        self.cornerRadius = cornerRadius
        self.colorScheme = colorScheme
        self.padding = padding
        self.lineWidth = lineWidth
        self.fontDesign = fontDesign
        #if os(iOS)
        UITextField.appearance().clearButtonMode = .whileEditing
        #endif
    }
}
