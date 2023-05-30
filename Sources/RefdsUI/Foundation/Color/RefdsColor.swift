//
//  RefdsColor.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import Foundation
import SwiftUI

public enum RefdsColor: Identifiable, CaseIterable {
    public var id: Color { return self.rawValue }
    
    case blue,
         brown,
         cyan,
         gray,
         green,
         indigo,
         mint,
         orange,
         pink,
         purple,
         red,
         teal,
         yellow,
         label,
         secondaryLabel
    
    public var rawValue: Color {
        switch self {
        case .blue: return .blue
        case .brown: return .brown
        case .cyan: return .cyan
        case .gray: return .gray
        case .green: return .green
        case .indigo: return .indigo
        case .mint: return .mint
        case .orange: return .orange
        case .pink: return .pink
        case .purple: return .purple
        case .red: return .red
        case .teal: return .teal
        case .yellow: return .yellow
        case .label: return .primary
        case .secondaryLabel: return .secondary
        }
    }
    
    public static var random: RefdsColor {
        RefdsColor.allCases.randomElement()!
    }
    
    public var random: RefdsColor {
        RefdsColor.random
    }
}

public extension Color {
    func refdsColor(_ color: RefdsColor) -> Color {
        color.rawValue
    }
}

public extension Collection where Element == RefdsColor {
    var asColor: [Color] { self.map { $0.rawValue } }
}
