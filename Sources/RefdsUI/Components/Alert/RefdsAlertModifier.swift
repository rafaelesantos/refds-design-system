//
//  RefdsAlertModifier.swift
//  
//
//  Created by Rafael Santos on 20/12/22.
//

import Foundation
import SwiftUI

public struct RefdsAlertModifier {
    @Binding private var isPresented: Bool

    private let title: String
    private let message: String
    private let dismissButton: RefdsAlertButton?
    private let primaryButton: RefdsAlertButton?
    private let secondaryButton: RefdsAlertButton?
}


extension RefdsAlertModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.fullScreenCover(isPresented: $isPresented) {
            RefdsAlert(title: title, message: message, dismissButton: dismissButton, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
}

public extension RefdsAlertModifier {
    init(title: String = "", message: String = "", dismissButton: RefdsAlertButton, isPresented: Binding<Bool>) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
        self.primaryButton = nil
        self.secondaryButton = nil
        _isPresented = isPresented
    }

    init(title: String = "", message: String = "", primaryButton: RefdsAlertButton, secondaryButton: RefdsAlertButton, isPresented: Binding<Bool>) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.dismissButton = nil
        _isPresented = isPresented
    }
}

public extension View {
    func refdsAlert(title: String, message: String, dismissButton: RefdsAlertButton = RefdsAlertButton("Ok"), isPresented: Binding<Bool>) -> some View {
        let title = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")
        return modifier(RefdsAlertModifier(title: title, message: message, dismissButton: dismissButton, isPresented: isPresented))
    }
    
    func refdsAlert(title: String, message: String, primaryButton: RefdsAlertButton, secondaryButton: RefdsAlertButton, isPresented: Binding<Bool>) -> some View {
        let title = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")
        return modifier(RefdsAlertModifier(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton, isPresented: isPresented))
    }
}
