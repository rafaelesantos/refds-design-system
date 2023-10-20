//
//  RefdsToggle.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import SwiftUI

public struct RefdsToggle: View {
    @Binding private var isOn: Bool
    private let style: Style
    private let content: (() -> any View)?
    private let alignment: Edge.Set
    private let color: RefdsColor
    
    public init(isOn: Binding<Bool>, style: Style = .toggle, alignment: Edge.Set = .trailing, color: RefdsColor = .accentColor, content: (() -> any View)? = nil) {
        self._isOn = isOn
        self.style = style
        self.content = content
        self.alignment = alignment
        self.color = color
    }
    
    public var body: some View {
        Toggle(isOn: $isOn, label: {
            if let content = content {
                AnyView(content())
            }
        }).toggleStyle(RefdsToggleStyle(isOn: $isOn, style: style, alignment: alignment, color: color))
    }
}

public extension RefdsToggle {
    enum Style {
        case checkbox
        case toggle
        case none
    }
}

struct RefdsToggleStyle: ToggleStyle {
    @Binding var isOn: Bool
    var style: RefdsToggle.Style
    var alignment: Edge.Set
    var color: RefdsColor
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        RefdsButton {
            withAnimation { isOn.toggle() }
        } label: {
            alignmentView(configuration: configuration)
        }
    }
    
    @ViewBuilder
    private func alignmentView(configuration: Configuration) -> some View {
        if style == .none {
            configuration.label
                .background(isOn ? color.opacity(0.1) : nil)
                .cornerRadius(10)
        } else {
            switch alignment {
            case .leading: leading(configuration: configuration)
            case .trailing: trailing(configuration: configuration)
            case .top: top(configuration: configuration)
            case .bottom: bottom(configuration: configuration)
            default: leading(configuration: configuration)
            }
        }
    }
    
    private func top(configuration: Configuration) -> some View {
        VStack {
            styleView.padding(.bottom, 8)
            configuration.label
        }
    }
    
    private func bottom(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            styleView.padding(.top, 8)
        }
    }
    
    private func leading(configuration: Configuration) -> some View {
        HStack {
            styleView.padding(.trailing, 10)
            configuration.label
        }
    }
    
    private func trailing(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            styleView.padding(.leading, 8)
        }
    }
    
    @ViewBuilder
    private var styleView: some View {
        switch style {
        case .checkbox: checkbox
        case .toggle: toggle
        case .none: EmptyView()
        }
    }
    
    private var checkbox: some View {
        RefdsIcon(symbol: .checkmarkCircleFill, color: isOn ? color : .secondary, size: 25, weight: .medium, renderingMode: .hierarchical)
            .scaleEffect(isOn ? 1 : 0.9)
            .animation(.default, value: isOn)
    }
    
    private var toggle: some View {
        Capsule(style: .continuous)
            .fill(isOn ? color : RefdsColor.secondary.opacity(0.15))
            .animation(.default, value: isOn)
        #if os(macOS)
            .frame(width: 45, height: 28)
        #else
            .frame(width: 55, height: 32)
        #endif
            .overlay(alignment: isOn ? .trailing: .leading) {
                Circle().fill(.white).padding(2.5)
            }
    }
}

struct RefdsToggleView: View {
    @State var isOn: Bool = false
    
    var body: some View {
        RefdsToggle(isOn: $isOn, style: .toggle, alignment: .trailing, color: .orange) {
            RefdsAlert(style: .inline(.critical, "Ops ocorreu um erro", .xmark))
                .padding()
        }
    }
}

struct RefdsToggle_Previews: PreviewProvider {
    static var previews: some View {
        RefdsToggleView()
            .padding()
    }
}
