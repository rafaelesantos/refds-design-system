//
//  RefdsAlertModifier.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import SwiftUI

public struct RefdsAlertModifier: ViewModifier {
    @Binding private var alert: RefdsAlert.ViewData?
    @State private var isAppear: Bool = false
    private let isBasicAlert: Bool
    
    public init(alert: Binding<RefdsAlert.ViewData?>) {
        self._alert = alert
        if let wrappedValue = alert.wrappedValue {
            isBasicAlert = wrappedValue.style == .basic(wrappedValue.style.basicType, wrappedValue.style.title, wrappedValue.style.message)
        } else {
            isBasicAlert = false
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainView()
                }.animation(.spring(), value: alert)
            )
            .onChange(of: alert) { _ in showAlert() }
    }
    
    @ViewBuilder func mainView() -> some View {
        if let alert = alert {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    RefdsAlert(
                        style: alert.style,
                        withBackground: true,
                        primaryAction: .init(title: alert.primaryAction?.title ?? "", action: { alert.primaryAction?.action?(); self.dismissToast() }),
                        secondaryAction: .init(title: alert.secondaryAction?.title ?? "", action: { alert.secondaryAction?.action?(); self.dismissToast() })
                    )
                    if isBasicAlert {
                        Spacer()
                    }
                }
                Spacer()
            }
            .transition(.move(edge: .bottom))
            .background(Color.black.opacity(isAppear && isBasicAlert ? 0.2 : 0))
        }
    }
    
    private func showAlert() {
        guard let alert = alert else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { isAppear = true }
        }
        #if os(macOS)
        #else
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
        let optionalDuration = alert.style.duration ?? (alert.primaryAction == nil && alert.secondaryAction == nil ? 5 : nil)
        guard let duration = optionalDuration else { return }
        if duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { dismissToast() }
        }
    }
    
    private func dismissToast() {
        withAnimation { isAppear = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation { alert = nil }
        }
    }
}

public extension View {
    func refdsAlert(viewData: Binding<RefdsAlert.ViewData?>) -> some View {
        self.modifier(RefdsAlertModifier(alert: viewData))
    }
}