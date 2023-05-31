//
//  RefdsCard.swift
//  
//
//  Created by Rafael Santos on 31/05/23.
//

import SwiftUI

public struct RefdsCard: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    
    public func body(content: Content) -> some View {
        Group {
            content.padding()
        }
        .background(Color.secondaryBackground(scheme: scheme))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.10), radius: 20, y: 5)
        .padding(10)
    }
}



public extension View {
    func refdsCard() -> some View {
        self.modifier(RefdsCard())
    }
}

struct RefdsCard_Previews: PreviewProvider {
    static var previews: some View {
        RefdsTag("Teste", color: .random)
            .refdsCard()
    }
}
