//
//  RefdsCollapse.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import SwiftUI

public struct RefdsCollapse: View {
    @Binding private var isCollapsed: Bool
    private var title: String?
    private var content: () -> any View
    private var header: (() -> any View)?
    
    public init(isCollapsed: Binding<Bool>, title: String, content: @escaping () -> any View) {
        self._isCollapsed = isCollapsed
        self.title = title
        self.content = content
    }
    
    public init(isCollapsed: Binding<Bool>, header: (() -> any View)? = nil, content: @escaping () -> any View) {
        self._isCollapsed = isCollapsed
        self.content = content
        self.header = header
    }
    
    public var body: some View {
        #if os(macOS)
        HStack { toggle }
            .background(.clear)
            .onTapGesture { withAnimation { isCollapsed.toggle() } }
        #else
        Button(.medium) {
            withAnimation { isCollapsed.toggle() }
        } label: { toggle }
        #endif
        if isCollapsed {
            AnyView(content())
        }
    }
    
    private var toggle: some View {
        HStack {
            if let title = title {
                RefdsText(title)
                Spacer()
            } else if let header = header {
                AnyView(header())
                Spacer()
            }
            
            RefdsIcon(symbol: .chevronUp, color: .accentColor, size: 17)
                .rotationEffect(.degrees(isCollapsed ? 0 : 180))
        }
    }
}

struct CollapsedView: View {
    @State var isCollapsed: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            RefdsCollapse(isCollapsed: $isCollapsed, title: "Toggle content") {
                ForEach(0...5, id: \.self) { _ in
                    RefdsTag("Round \(Int.random(in: 150...980))", color: .random)
                }
            }
        }
    }
}

struct RefdsCollapse_Previews: PreviewProvider {
    static var previews: some View {
        RefdsList { _ in
            RefdsRow {
                CollapsedView()
                    .padding()
            }
        }
    }
}
