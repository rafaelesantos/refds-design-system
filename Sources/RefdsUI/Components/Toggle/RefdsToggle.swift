//
//  RefdsToggle.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import SwiftUI

public struct RefdsToggle: View {
    @Binding private var isOn: Bool
    private let content: (() -> any View)?
    
    public init(
        isOn: Binding<Bool>,
        content: (() -> any View)? = nil
    ) {
        self._isOn = isOn
        self.content = content
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            if let content = content {
                AnyView(content())
            }
        }
        .toggleStyle(.switch)
        .tint(RefdsUI.shared.accentColor)
    }
}

struct RefdsToggleView: View {
    @State var isOn: Bool = false
    
    var body: some View {
        RefdsToggle(isOn: $isOn) {
            RefdsAlert(style: .inline(.critical, "Ops ocorreu um erro", .xmark))
        }
    }
}

struct RefdsToggle_Previews: PreviewProvider {
    static var previews: some View {
        RefdsToggleView()
            .padding()
            .padding()
    }
}
