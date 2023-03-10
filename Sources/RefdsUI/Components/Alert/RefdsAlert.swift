//
//  RefdsAlert.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI

/// Custom Alert
struct RefdsAlert<Content, Actions>: View where Content: View, Actions: View {
    var title: Text?
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> Content
    @ViewBuilder var actions: () -> Actions
    
    // Size holders to enable scrolling of the content if needed
    @State private var viewSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var actionsSize: CGSize = .zero
    
    @State private var fitInScreen = false
    
    // Used to animate the appearance
    @State private var isShowing = false
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                if isShowing {
                    alert
                        .animation(nil, value: height)
                }
                Spacer()
            }
        }
        .captureSize($viewSize)
        .onAppear {
            withAnimation {
                isShowing = true
            }
        }
    }
    
    var height: CGFloat {
        let maxHeight = viewSize.height - 60 - actionsSize.height
        let min = min(maxHeight, contentSize.height)
        return max(min, 0)
    }
    
    var minWidth: CGFloat {
        let maxWidth = viewSize.width - 60
        let min = min(maxWidth, contentSize.width)
        return max(min, 0)
    }
    
    var maxWidth: CGFloat {
        let maxWidth = viewSize.width - 60
        let min = min(maxWidth, contentSize.width)
        return max(min, 270)
    }
    
    var alert: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: 4) {
                        title?
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        content()
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .captureSize($contentSize)
                    .environment(\.isEnabled, true)
                }
                .frame(height: height)
                .onUpdate(of: contentSize) { contentSize in
                    fitInScreen = contentSize.height <= proxy.size.height
                }
                .disabled(fitInScreen)
            }
            .frame(height: height)
            
            _VariadicView.Tree(ContentLayout(isPresented: $isPresented), content: actions)
                .buttonStyle(.alert)
                .captureSize($actionsSize)
        }
        .frame(minWidth: minWidth, maxWidth: maxWidth)
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(13.3333)
        .padding(30)
        .transition(.opacity.combined(with: .scale(scale: 1.1)))
        .animation(.default, value: isPresented)
    }
}

struct ContentLayout: _VariadicView_ViewRoot {
    @Binding var isPresented: Bool
    
    func body(children: _VariadicView.Children) -> some View {
        VStack(spacing: 0) {
            ForEach(children) { child in
                Divider()
                child
                    .simultaneousGesture(TapGesture().onEnded { _ in
                        isPresented = false
                        // Workaround for iOS 13
                        if #available(iOS 15, *) { } else {
                            RefdsAlertWindow.dismiss()
                        }
                    })
            }
        }
    }
}
