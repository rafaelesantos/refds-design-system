//
//  File.swift
//  
//
//  Created by Rafael Santos on 20/02/23.
//

import Foundation
import SwiftUI

public struct NavigationModifier: ViewModifier {
    @Binding public var presentingView: AnyView?
    
    public init(presentingView: Binding<AnyView?>) {
        self._presentingView = presentingView
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                NavigationLink(destination: self.presentingView, isActive: Binding(
                    get: { self.presentingView != nil },
                    set: { if !$0 {
                        self.presentingView = nil
                    }})
                ) {
                    EmptyView()
                }
            )
    }
}

public struct SheetModifier: ViewModifier {
    @Binding public var presentingView: AnyView?
    
    public init(presentingView: Binding<AnyView?>) {
        self._presentingView = presentingView
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: Binding(
                get: { self.presentingView != nil },
                set: { if !$0 {
                    self.presentingView = nil
                }})
            ) {
                self.presentingView
            }
            
    }
}
