//
//  RefdsList.swift
//  
//
//  Created by Rafael Santos on 31/05/23.
//

import SwiftUI

public struct RefdsList<Content: View, Style: ListStyle>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let style: Style
    private let content: (GeometryProxy) -> Content
    
    #if os(macOS)
    public init(style: Style = .plain, @ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.style = style
        self.content = content
    }
    #else
    public init(style: Style = .insetGrouped, @ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.style = style
        self.content = content
    }
    #endif
    
    public var body: some View {
        GeometryReader { proxy in
            if isLargeScreen {
                macOSView(proxy: proxy)
            } else {
                iOSView(proxy: proxy)
            }
        }
    }
    
    private func macOSView(proxy: GeometryProxy) -> some View  {
        ScrollView {
            content(proxy)
        }
        .background(Color.background(scheme: colorScheme))
    }
    
    private func iOSView(proxy: GeometryProxy) -> some View {
        List {
            content(proxy)
        }
        .listStyle(style)
    }
}

struct RefdsList_Previews: PreviewProvider {
    static var previews: some View {
        RefdsList { proxy in
            
        }
    }
}
