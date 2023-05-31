//
//  RefdsButton.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import SwiftUI

public struct RefdsButton: View {
    private let title: String
    private let color: RefdsColor
    private let style: Style
    private let content: (() -> any View)?
    private let action: (() -> Void)?
    private let maxSize: Bool
    
    public init(_ title: String, color: RefdsColor = .accentColor, style: Style = .primary, maxSize: Bool = true, action: (() -> Void)? = nil) {
        self.title = title
        self.color = color
        self.style = style
        self.action = action
        self.maxSize = maxSize
        self.content = nil
    }
    
    public init(action: (() -> Void)? = nil, label: (() -> any View)? = nil) {
        self.title = ""
        self.color = .accentColor
        self.style = .custom
        self.content = label
        self.action = action
        self.maxSize = false
    }
    
    public var body: some View {
        switch style {
        case .primary: primary
        case .secondary: secondary
        case .tertiary: tertiary
        case .custom: custom
        }
    }
    
    private var primary: some View {
        #if os(iOS)
        Button(.medium) { action?() } label: {
            RefdsText(title, style: .body, color: .white, weight: .bold, alignment: .center)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding()
        }
        .background(color)
        .cornerRadius(10)
        
        #else
        HStack {
            RefdsText(title, style: .body, color: .white, weight: .bold, alignment: .center)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding()
        }
        .background(color)
        .cornerRadius(10)
        .onTapGesture { action?() }
        #endif
    }
    
    private var secondary: some View {
        #if os(iOS)
        Button(.medium) { action?() } label: {
            RefdsText(title, style: .body, color: color, weight: .bold, alignment: .center)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(color, lineWidth: 1.5)
                }
        }
        .background(color.opacity(0.1))
        .cornerRadius(10)
        #else
        HStack {
            RefdsText(title, style: .body, color: color, weight: .bold, alignment: .center)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(color, lineWidth: 1.5)
                }
        }
        .background(color.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture { action?() }
        #endif
    }
    
    private var tertiary: some View {
        #if os(iOS)
        Button(.medium) { action?() } label: {
            RefdsText(title, style: .body, color: color, weight: .bold, alignment: .center)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding()
        }
        
        #else
        HStack {
            RefdsText(title, style: .body, color: color, weight: .bold, alignment: .center)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding()
        }
        .onTapGesture { action?() }
        #endif
    }
    
    @ViewBuilder
    private var custom: some View {
        if let content = content {
            #if os(iOS)
            Button(.medium) { action?() } label: {
                AnyView(content())
            }
            #else
            HStack {
                AnyView(content())
            }
            .onTapGesture { action?() }
            #endif
        }
    }
}

public extension RefdsButton {
    enum Style {
        case primary
        case secondary
        case tertiary
        case custom
    }
}

struct RefdsButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RefdsButton("Presentation Button", style: .primary)
            RefdsButton("Presentation Button", style: .secondary)
            RefdsButton("Presentation Button", style: .tertiary)
        }
        .padding()
    }
}
