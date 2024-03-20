import SwiftUI

public class RefdsUI {
    public static let shared = RefdsUI()
    
    public var accentColor: RefdsColor
    public var cornerRadius: CGFloat
    public var colorScheme: ColorScheme?
    public var padding: RefdsPadding
    
    public init(
        accentColor: RefdsColor = .green,
        cornerRadius: CGFloat = 8,
        colorScheme: ColorScheme? = nil,
        padding: RefdsPadding = .default
    ) {
        self.accentColor = accentColor
        self.cornerRadius = cornerRadius
        self.colorScheme = colorScheme
        self.padding = padding
    }
}
