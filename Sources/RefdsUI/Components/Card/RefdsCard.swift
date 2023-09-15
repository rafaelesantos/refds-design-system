//
//  RefdsCard.swift
//  
//
//  Created by Rafael Santos on 31/05/23.
//

import SwiftUI

public struct RefdsCard: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    private let withShadow: Bool
    
    public init(withShadow: Bool = true) {
        self.withShadow = withShadow
    }
    
    public func body(content: Content) -> some View {
        if withShadow {
            Group {
                content.padding()
            }
            .background(Color.secondaryBackground(scheme: scheme))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.10), radius: 20, y: 5)
            .padding(.all, 2)
        } else {
            Group {
                content.padding()
            }
            .background(Color.secondaryBackground(scheme: scheme))
            .cornerRadius(10)
        }
    }
}



public extension View {
    func refdsCard(withShadow: Bool = true) -> some View {
        self.modifier(RefdsCard(withShadow: withShadow))
    }
}

struct RefdsCard_Previews: PreviewProvider {
    static var previews: some View {
        RefdsTag("Teste", color: .random)
            .refdsCard()
    }
}
