//
//  RefdsAlertButton.swift
//  
//
//  Created by Rafael Santos on 20/12/22.
//

import SwiftUI

public struct RefdsAlertButton: View {
    let content: String
    let style: Style
    var action: (() -> Void)? = nil
    
    public init(_ content: String, style: Style = .default, action: (() -> Void)? = nil) {
        self.content = content
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button { action?() } label: {
            RefdsText(content, size: .large, color: style.foregroundColor, weight: .medium, lineLimit: 1)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .background(style.backgroundColor)
        .cornerRadius(10)
    }
}

extension RefdsAlertButton {
    public enum Style {
        case `default`
        case cancel
        case custom(color: Color)
        
        var backgroundColor: Color {
            switch self {
            case .default: return Color(uiColor: .secondarySystemBackground)
            case .cancel: return .red.opacity(0.2)
            case let .custom(color): return color.opacity(0.2)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .default: return .primary
            case .cancel: return .red
            case let .custom(color): return color
            }
        }
    }
}

struct RefdsAlertButton_Previews: PreviewProvider {
    static var previews: some View {
        RefdsAlertButton("OK")
            .padding()
            .previewDisplayName("Default")
        
        RefdsAlertButton("Cancel", style: .cancel)
            .padding()
            .previewDisplayName("Cancel")
        
        RefdsAlertButton("Custom", style: .custom(color: .green))
            .padding()
            .previewDisplayName("Custom")
    }
}
