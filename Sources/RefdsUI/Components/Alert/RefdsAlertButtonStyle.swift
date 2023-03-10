//
//  RefdsAlertButtonStyle.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI

public struct RefdsAlertButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.alertButtonHeight) var maxHeight
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Spacer()
            label(configuration: configuration)
                .lineLimit(0)
                .minimumScaleFactor(0.66)
                .truncationMode(.middle)
            Spacer()
        }
        .padding(12)
        .frame(maxHeight: maxHeight)
        .background(background(configuration: configuration))
    }
    
    @ViewBuilder
    func label(configuration: Self.Configuration) -> some View {
        if #available(iOS 15, *) {
            switch configuration.role {
            case .some(.destructive):
                configuration.label
                    .font(.body)
                    .foregroundColor(.red)
            case .some(.cancel):
                configuration.label
                    .font(.headline)
                    .foregroundColor(.accentColor)
            default:
                configuration.label
                    .font(.body)
                    .foregroundColor(.accentColor)
            }
        } else {
            configuration.label
                .font(.body)
                .foregroundColor(.accentColor)
        }
    }
    
    @ViewBuilder
    func background(configuration: Self.Configuration) -> some View {
        if configuration.isPressed {
            switch colorScheme {
            case .dark:
                Color.white.opacity(0.135)
            case .light:
                Color.black.opacity(0.085)
            @unknown default:
                Color.primary.opacity(0.085)
            }
        } else {
            Color.almostClear
        }
    }
}

extension ButtonStyle where Self == RefdsAlertButtonStyle {
    public static var alert: Self {
        RefdsAlertButtonStyle()
    }
}

struct AlertButtonHeightKey: EnvironmentKey {
    static var defaultValue: CGFloat? {
        nil
    }
}

extension EnvironmentValues {
    var alertButtonHeight: CGFloat? {
        get {
            self[AlertButtonHeightKey.self]
        }
        set {
            self[AlertButtonHeightKey.self] = newValue
        }
    }
}
