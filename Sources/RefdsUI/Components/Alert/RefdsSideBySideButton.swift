//
//  RefdsSideBySideButton.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI

public struct RefdsMultiButton<Content>: View where Content: View {
    @ViewBuilder public var content: () -> Content
    
    public var body: some View {
        _VariadicView.Tree(ContentLayout(), content: content)
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    struct ContentLayout: _VariadicView_ViewRoot {
        func body(children: _VariadicView.Children) -> some View {
            HStack(spacing: 0) {
                children.first
                ForEach(children.dropFirst()) { child in
                    Divider()
                    child
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .buttonStyle(.alert)
            .environment(\.alertButtonHeight, .infinity)
        }
    }
}

@available(*, deprecated, message: "Prefer using `RefdsMultiButton` instead.")
public struct RefdsSideBySideButton<LeftContent, RightContent>: View where LeftContent: View, RightContent: View {
    var buttonLeft: Button<LeftContent>
    var buttonRight: Button<RightContent>
    
    public var body: some View {
        HStack(spacing: 0) {
            buttonLeft
                .frame(maxWidth: .infinity)
            Divider()
            buttonRight
                .frame(maxWidth: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true)
        .buttonStyle(.alert)
        .environment(\.alertButtonHeight, .infinity)
    }
    
    @available(iOS 15, *)
    public init(roleLeft: ButtonRole? = nil,
                roleRight: ButtonRole? = nil,
                actionLeft: @escaping () -> Void,
                actionRight: @escaping () -> Void,
                @ViewBuilder labelLeft: @escaping () -> LeftContent,
                @ViewBuilder labelRight: @escaping () -> RightContent) {
        self.buttonLeft = Button(role: roleLeft, action: actionLeft, label: labelLeft)
        self.buttonRight = Button(role: roleRight, action: actionRight, label: labelRight)
    }
    
    @_disfavoredOverload public init(actionLeft: @escaping () -> Void,
                actionRight: @escaping () -> Void,
                @ViewBuilder labelLeft: @escaping () -> LeftContent,
                @ViewBuilder labelRight: @escaping () -> RightContent) {
        self.buttonLeft = Button(action: actionLeft, label: labelLeft)
        self.buttonRight = Button(action: actionRight, label: labelRight)
    }
}
