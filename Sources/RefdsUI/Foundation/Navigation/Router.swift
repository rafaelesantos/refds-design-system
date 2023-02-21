//
//  File.swift
//  
//
//  Created by Rafael Santos on 19/02/23.
//

import Foundation
import SwiftUI

// MARK: - State
public struct RouterState {
    public var navigating: AnyView? = nil
    public var presentingSheet: AnyView? = nil
    public var isPresented: Binding<Bool>
}

// MARK: - Router
public class Router<Factory>: ObservableObject {
    @Published public private(set) var state: RouterState
    public private(set) var factory: Factory
    
    public init(isPresented: Binding<Bool>, factory: Factory) {
        state = RouterState(isPresented: isPresented)
        self.factory = factory
    }
}

public extension Router {
    func navigateTo<V: View>(_ view: V) {
        state.navigating = AnyView(view)
    }
    
    func presentSheet<V: View>(_ view: V) {
        state.presentingSheet = AnyView(view)
    }
    
    func dismiss() {
        state.isPresented.wrappedValue = false
    }
}


public extension Router {
    var isNavigating: Binding<Bool> {
        boolBinding(keyPath: \.navigating)
    }
    
    var isPresentingSheet: Binding<Bool> {
        boolBinding(keyPath: \.presentingSheet)
    }
    
    var isPresented: Binding<Bool> {
        state.isPresented
    }
}

private extension Router {
    func binding<T>(keyPath: WritableKeyPath<RouterState, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
    
    func boolBinding<T>(keyPath: WritableKeyPath<RouterState, T?>) -> Binding<Bool> {
        Binding(
            get: { self.state[keyPath: keyPath] != nil },
            set: {
                if !$0 {
                    self.state[keyPath: keyPath] = nil
                }
            }
        )
    }
}

extension View {
    func navigation<Factory>(_ router: Router<Factory>) -> some View {
        self.modifier(NavigationModifier(presentingView: router.binding(keyPath: \.navigating)))
    }
    
    func sheet<Factory>(_ router: Router<Factory>) -> some View {
        self.modifier(SheetModifier(presentingView: router.binding(keyPath: \.presentingSheet)))
    }
}
