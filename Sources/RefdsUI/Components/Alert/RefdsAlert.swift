//
//  RefdsAlert.swift
//  
//
//  Created by Rafael Santos on 20/12/22.
//

import SwiftUI

public struct RefdsAlert: View {
    let title: String
    let message: String
    let dismissButton: RefdsAlertButton?
    let primaryButton: RefdsAlertButton?
    let secondaryButton: RefdsAlertButton?
    
    @State private var opacity: CGFloat = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat = 0.001
    
    public init(title: String, message: String, dismissButton: RefdsAlertButton? = nil, primaryButton: RefdsAlertButton? = nil, secondaryButton: RefdsAlertButton? = nil) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        ZStack {
            alertView
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .task { animate(isShown: true) }
    }
    
    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 10) {
            titleView
            messageView
            buttonsView
        }
        .padding(24)
        .frame(width: 320)
        .background(.bar)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 12)
    }
    
    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            RefdsText(title, size: .large, weight: .bold)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var messageView: some View {
        if !message.isEmpty {
            RefdsText(message, size: title.isEmpty ? .large : .normal, color: title.isEmpty ? .primary : .secondary, weight: title.isEmpty ? .bold : .regular)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var buttonsView: some View {
        HStack(spacing: 12) {
            if dismissButton != nil {
                dismissButtonView
            } else if primaryButton != nil, secondaryButton != nil {
                secondaryButtonView
                primaryButtonView
            }
        }
    }
    
    @ViewBuilder
    private var primaryButtonView: some View {
        if let button = primaryButton {
            RefdsAlertButton(button.content, style: button.style) {
                animate(isShown: false) {
                    dismiss()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }
    
    @ViewBuilder
    private var secondaryButtonView: some View {
        if let button = secondaryButton {
            RefdsAlertButton(button.content, style: button.style) {
                animate(isShown: false) { dismiss() }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }
    
    @ViewBuilder
    private var dismissButtonView: some View {
        if let button = dismissButton {
            RefdsAlertButton(button.content, style: button.style) {
                animate(isShown: false) {
                    dismiss()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }
    
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { completion?() }
        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion?() }
        }
    }
}

struct RefdsAlert_Previews: PreviewProvider {
    static let dismissButton = RefdsAlertButton("OK")
    static let primaryButton = RefdsAlertButton("OK")
    static let secondaryButton = RefdsAlertButton("Cancel", style: .cancel)
    @State static var isPresented = true
    
    static let title = "This is your life. Do what you want and do it often."
    static let message = "If you don't like something, change it.\nIf you don't like your job, quit.\nIf you don't have enough time, stop watching TV."
    
    static var previews: some View {
        RefdsAlert(title: title, message: message, primaryButton: nil, secondaryButton: nil)
            .previewDisplayName("Alert ok button")
        
        RefdsAlert(title: title, message: message, dismissButton: dismissButton, primaryButton: nil, secondaryButton: nil)
            .previewDisplayName("Alert ok button")
        
        RefdsAlert(title: title, message: message, dismissButton: nil, primaryButton: primaryButton, secondaryButton: secondaryButton)
            .previewDisplayName("Alert two buttons")
    }
}
