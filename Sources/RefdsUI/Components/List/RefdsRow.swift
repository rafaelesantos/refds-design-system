//
//  RefdsRow.swift
//  
//
//  Created by Rafael Santos on 31/05/23.
//

import SwiftUI

public struct RefdsRow<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    @State private var isPresented: Bool = false
    
    private let presentationStyle: RefdsPresentationStyle
    private let showArrowDestination: Bool
    private let content: () -> Content
    private let destination: (() -> any View)?
    private let action: (() -> Void)?
    
    public init(_ presentationStyle: RefdsPresentationStyle = .push, showArrowDestination: Bool = true, action: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content, destination: (() -> any View)? = nil) {
        self.presentationStyle = presentationStyle
        self.showArrowDestination = showArrowDestination
        self.content = content
        self.destination = destination
        self.action = action
    }
    
    @ViewBuilder
    public var body: some View {
        if let destination = destination, let action = action {
            button(destination: destination, action: action)
        } else if let destination = destination {
            button(destination: destination)
        } else if let action = action {
            button(action: action)
        } else {
            label
        }
    }
    
    private func button(destination: @escaping () -> any View) -> some View {
        #if os(macOS)
        label.background(.clear).onTapGesture {
            withAnimation { isPresented.toggle() }
        }.refdsNavigation(presentationStyle, isPresented: $isPresented) {
            AnyView(destination())
        }
        #else
        Button(.medium) {
            withAnimation { isPresented.toggle() }
        } label: { label }.refdsNavigation(presentationStyle, isPresented: $isPresented) {
            AnyView(destination())
        }
        #endif
    }
    
    private func button(action: @escaping () -> Void) -> some View {
        #if os(macOS)
        label.background(.clear).onTapGesture {
            withAnimation { action() }
        }
        #else
        Button(.medium) {
            withAnimation { action() }
        } label: { label }
        #endif
    }
    
    private func button(destination: @escaping () -> any View, action: @escaping () -> Void) -> some View {
        #if os(macOS)
        label.background(.clear).onTapGesture {
            action()
            withAnimation { isPresented.toggle() }
        }.refdsNavigation(presentationStyle, isPresented: $isPresented) {
            AnyView(destination())
        }
        #else
        Button(.medium) {
            action()
            withAnimation { isPresented.toggle() }
        } label: { label }.refdsNavigation(presentationStyle, isPresented: $isPresented) {
            AnyView(destination())
        }
        #endif
    }
    
    private var label: some View {
        HStack {
            content()
            Spacer()
            if showArrowDestination, destination != nil {
                RefdsIcon(symbol: .chevronRight, color: .secondary.opacity(0.4), size: 17)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

public enum RefdsPresentationStyle {
    case sheet
    case push
}

public extension View {
    @ViewBuilder
    func refdsNavigation<Destination: View>(_ style: RefdsPresentationStyle = .sheet, isPresented: Binding<Bool>, destination: @escaping () -> Destination) -> some View {
        switch style {
        case .push:
            self.background(
                NavigationLink(
                    destination: destination(),
                    isActive: isPresented
                ) { EmptyView() }.hidden()
            )
        case .sheet:
            self.sheet(
                isPresented: isPresented,
                content: {
                    NavigationView {
                        destination()
                            .toolbar {
                                ToolbarItem(placement: .automatic) {
                                    RefdsButton { isPresented.wrappedValue.toggle() } label: {
                                        RefdsIcon(
                                            symbol: .xmarkCircleFill,
                                            color: .secondary.opacity(0.5),
                                            size: 20
                                        )
                                    }
                                }
                            }
                    }
                }
            )
        }
    }
}

struct RefdsRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RefdsList {
                RefdsSection(proxy: $0) {
                    RefdsRow {
                        RefdsText("Lorem Ipsum")
                    } destination: {
                        RefdsTag("Lorem Ipsum", color: .random)
                    }
                    
                    RefdsRow(.sheet) {
                        RefdsText("Lorem Ipsum 2")
                    } destination: {
                        RefdsTag("Lorem Ipsum 1", color: .random)
                    }
                }
                
                RefdsSection(proxy: $0) {
                    RefdsRow(.sheet) {
                        RefdsText("Lorem Ipsum 2")
                    } destination: {
                        RefdsTag("Lorem Ipsum 1", color: .random)
                    }
                }
            }
        }
    }
}
