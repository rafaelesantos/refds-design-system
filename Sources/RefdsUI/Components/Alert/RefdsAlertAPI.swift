//
//  RefdsAlertAPI.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI
import Combine
import WindowSceneReader

public extension View {
    func refdsAlert<Content, Actions>(_ title: Text? = nil,
                                       isPresented: Binding<Bool>,
                                       @ViewBuilder content: @escaping () -> Content,
                                       @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Content: View, Actions: View {
        background(WindowSceneReader { windowScene in
            refdsAlert(title, isPresented: isPresented, on: windowScene, content: content, actions: actions)
        })
        .disabled(isPresented.wrappedValue)
    }
    
    func refdsAlert<Content, Actions>(_ title: LocalizedStringKey,
                                       isPresented: Binding<Bool>,
                                       @ViewBuilder content: @escaping () -> Content,
                                       @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Content: View, Actions: View {
        refdsAlert(Text(title), isPresented: isPresented, content: content, actions: actions)
    }
    
    func refdsAlert<Title, Content, Actions>(_ title: Title,
                                              isPresented: Binding<Bool>,
                                              @ViewBuilder content: @escaping () -> Content,
                                              @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Title: StringProtocol, Content: View, Actions: View {
        refdsAlert(Text(title), isPresented: isPresented, content: content, actions: actions)
    }
    
    func refdsAlert<Content, Actions>(isPresented: Binding<Bool>,
                                       title: @escaping () -> Text?,
                                       @ViewBuilder content: @escaping () -> Content,
                                       @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Content: View, Actions: View {
        refdsAlert(title(), isPresented: isPresented, content: content, actions: actions)
    }
}

public extension View {
    
    @ViewBuilder func refdsAlert<Content, Actions>(_ title: Text? = nil,
                                                    isPresented: Binding<Bool>,
                                                    on windowScene: UIWindowScene,
                                                    @ViewBuilder content: @escaping () -> Content,
                                                    @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Content: View, Actions: View {
        if #available(iOS 14, *) {
            onChange(of: isPresented.wrappedValue) { value in
                if value {
                    RefdsAlertWindow.present(on: windowScene) {
                        RefdsAlert(title: title, isPresented: isPresented, content: content, actions: actions)
                    }
                } else {
                    RefdsAlertWindow.dismiss(on: windowScene)
                }
            }
            .onAppear {
                guard isPresented.wrappedValue else { return }
                RefdsAlertWindow.present(on: windowScene) {
                    RefdsAlert(title: title, isPresented: isPresented, content: content, actions: actions)
                }
            }
            .onDisappear {
                RefdsAlertWindow.dismiss(on: windowScene)
            }
        } else {
            onReceive(Just(isPresented.wrappedValue)) { value in
                if value {
                    RefdsAlertWindow.present(on: windowScene) {
                        RefdsAlert(title: title, isPresented: isPresented, content: content, actions: actions)
                    }
                } else { }
            }
            .onDisappear {
                RefdsAlertWindow.dismiss(on: windowScene)
            }
        }
    }
    
    func refdsAlert<Content, Actions>(_ title: LocalizedStringKey,
                                       isPresented: Binding<Bool>,
                                       on windowScene: UIWindowScene,
                                       @ViewBuilder content: @escaping () -> Content,
                                       @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Content: View, Actions: View {
        self.refdsAlert(Text(title), isPresented: isPresented, on: windowScene, content: content, actions: actions)
    }
    
    func refdsAlert<Title, Content, Actions>(_ title: Title,
                                              isPresented: Binding<Bool>,
                                              on windowScene: UIWindowScene,
                                              @ViewBuilder content: @escaping () -> Content,
                                              @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Title: StringProtocol, Content: View, Actions: View {
        self.refdsAlert(Text(title), isPresented: isPresented, on: windowScene, content: content, actions: actions)
    }
    
    func refdsAlert<Content, Actions>(isPresented: Binding<Bool>,
                                       on windowScene: UIWindowScene,
                                       title: @escaping () -> Text?,
                                       @ViewBuilder content: @escaping () -> Content,
                                       @ViewBuilder actions: @escaping () -> Actions) -> some View
    where Content: View, Actions: View {
        refdsAlert(title(), isPresented: isPresented, on: windowScene, content: content, actions: actions)
    }
}

public extension View {
    
    func refdsAlert<Content>(_ title: Text? = nil,
                              isPresented: Binding<Bool>,
                              @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        refdsAlert(title, isPresented: isPresented, content: content, actions: { /* no actions */ })
    }
    
    func refdsAlert<Content>(_ title: LocalizedStringKey,
                              isPresented: Binding<Bool>,
                              @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        refdsAlert(Text(title), isPresented: isPresented, content: content, actions: { /* no actions */ })
    }
    
    func refdsAlert<Title, Content>(_ title: Title,
                                     isPresented: Binding<Bool>,
                                     @ViewBuilder content: @escaping () -> Content) -> some View
    where Title: StringProtocol, Content: View {
        refdsAlert(Text(title), isPresented: isPresented, content: content, actions: { /* no actions */ })
    }
    
    func refdsAlert<Content>(isPresented: Binding<Bool>,
                              title: @escaping () -> Text?,
                              @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        refdsAlert(title(), isPresented: isPresented, content: content, actions: { /* no actions */ })
    }
}
