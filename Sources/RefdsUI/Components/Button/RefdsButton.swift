//
//  RefdsButton.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import SwiftUI

public struct RefdsButton: View {
    @State private var isPressed: Bool = false
    
    private let title: String
    private let color: RefdsColor
    private let style: Style
    private let font: RefdsText.Style
    private let content: (() -> any View)?
    private let action: (() -> Void)?
    private let maxSize: Bool
    
    public init(_ title: String, color: RefdsColor = .accentColor, style: Style = .primary, font: RefdsText.Style = .body, maxSize: Bool = true, action: (() -> Void)? = nil) {
        self.title = title
        self.color = color
        self.style = style
        self.action = action
        self.maxSize = maxSize
        self.font = font
        self.content = nil
    }
    
    public init(action: (() -> Void)? = nil, label: (() -> any View)? = nil) {
        self.title = ""
        self.color = .accentColor
        self.style = .custom
        self.content = label
        self.action = action
        self.font = .body
        self.maxSize = false
    }
    
    public var body: some View {
        Group {
            switch style {
            case .primary: primary
            case .secondary: secondary
            case .tertiary: tertiary
            case .custom: custom
            }
        }
        .scaleEffect(isPressed ? 1.05 : 1)
    }
    
    private var primary: some View {
        #if os(iOS)
        Button(.medium) { pressButton() } label: {
            RefdsText(title, style: font, color: .white, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding(14)
        }
        .background(color)
        .clipShape(Capsule())
        
        #else
        HStack {
            RefdsText(title, style: font, color: .white, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding(14)
        }
        .background(color)
        .clipShape(Capsule())
        .onTapGesture { pressButton() }
        #endif
    }
    
    private var secondary: some View {
        #if os(iOS)
        Button(.medium) { pressButton() } label: {
            RefdsText(title, style: font, color: color, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding(14)
                .overlay {
                    Capsule(style: .circular)
                        .stroke(color, lineWidth: 2)
                }
        }
        .clipShape(Capsule())
        #else
        HStack {
            RefdsText(title, style: font, color: color, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding(14)
                .overlay {
                    Capsule(style: .circular)
                        .stroke(color, lineWidth: 2)
                }
        }
        .clipShape(Capsule())
        .onTapGesture { pressButton() }
        #endif
    }
    
    private var tertiary: some View {
        #if os(iOS)
        Button(.medium) { pressButton() } label: {
            RefdsText(title, style: font, color: color, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding(14)
        }
        
        #else
        HStack {
            RefdsText(title, style: font, color: color, weight: .bold, alignment: .center, lineLimit: 1)
                .frame(maxWidth: maxSize ? .infinity : nil)
                .padding(14)
        }
        .onTapGesture { pressButton() }
        #endif
    }
    
    @ViewBuilder
    private var custom: some View {
        if let content = content {
            #if os(iOS)
            Button(.medium) {
                isPressed.toggle()
                action?()
            } label: {
                AnyView(content())
            }
            #else
            HStack {
                AnyView(content())
            }
            .onTapGesture {
                isPressed.toggle()
                action?()
            }
            #endif
        }
    }
    
    private func pressButton() {
        withAnimation {
            isPressed.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.isPressed.toggle()
            }
            self.action?()
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
        .padding(14)
    }
}
