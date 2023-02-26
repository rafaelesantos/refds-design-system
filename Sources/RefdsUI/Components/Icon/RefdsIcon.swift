//
//  RefdsIcon.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI

public struct RefdsIcon: View {
    private let symbol: RefdsIconSymbol
    private let color: Color
    private let size: CGFloat
    private let weight: SwiftUI.Font.Weight
    private let renderingMode: SymbolRenderingMode
    
    public init(
        symbol: RefdsIconSymbol,
        color: Color = .accentColor,
        size: CGFloat = 25,
        weight: Font.Weight = .regular,
        renderingMode: SymbolRenderingMode = .monochrome
    ) {
        self.symbol = symbol
        self.color = color
        self.size = size
        self.weight = weight
        self.renderingMode = renderingMode
    }
    
    public var body: some View {
        Image(systemName: symbol.rawValue)
            .font(SwiftUI.Font.system(size: size, weight: weight))
            .symbolRenderingMode(renderingMode)
            .foregroundColor(color)
    }
}

struct RefdsIcon_Previews: PreviewProvider {
    static var previews: some View {
        RefdsIcon(symbol: .infinity)
    }
}
