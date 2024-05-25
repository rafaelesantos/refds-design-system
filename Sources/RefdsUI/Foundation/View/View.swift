import SwiftUI
import RefdsShared

public extension View {
    func refdsBackground(with style: RefdsBackgroundModifier.Style = .background) -> some View {
        modifier(RefdsBackgroundModifier(style: style))
    }
    
    func refdsBorder(
        color: Color = .placeholder,
        padding: CGFloat.Padding = .medium,
        radius: CGFloat = .cornerRadius,
        lineWidth: CGFloat = .lineWidth
    ) -> some View {
        self
            .padding(padding.rawValue)
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .stroke(color, lineWidth: lineWidth)
            }
    }
    
    @ViewBuilder
    func refdsTextState(for state: RefdsTextFieldState?) -> some View {
        if let state = state {
            VStack(spacing: .padding(.extraSmall)) {
                self
                HStack {
                    RefdsText(
                        state.description,
                        style: .footnote,
                        color: state.color,
                        design: .default,
                        alignment: .leading
                    )
                    Spacer(minLength: .zero)
                }
            }
        }
    }
    
    func refdsCard(
        padding: CGFloat.Padding = .medium,
        hasShadow: Bool = true,
        hasMaterial: Bool = false
    ) -> some View {
        self
            .padding(.padding(padding))
            .if(hasMaterial) {
                $0.background(.ultraThinMaterial)
            }
            .if(!hasMaterial) {
                $0.refdsBackground(with: .secondaryBackground)
            }
            .cornerRadius(.cornerRadius)
            .if(hasShadow) {
                $0.shadow(
                    color: .black.opacity(0.07),
                    radius: .cornerRadius / 1.2
                )
            }
    }
    
    func refdsLoading(_ isLoading: Bool) -> some View {
        ZStack(alignment: .center) {
            self
            if isLoading { RefdsLoadingView() }
        }
    }
    
    func refdsScaleEffect() -> some View {
        modifier(RefdsScaleEffect())
    }
    
    func refdsAlert(item: Binding<RefdsAlertViewData?>) -> some View {
        ZStack {
            self
            if let viewData = item.wrappedValue {
                VStack {
                    Spacer()
                    RefdsAlertView(
                        image: viewData.image,
                        title: viewData.title,
                        message: viewData.message,
                        content: viewData.content,
                        actions: viewData.actions,
                        dismiss: { item.wrappedValue = nil }
                    )
                    .refdsScaleEffect()
                    Spacer()
                }
                .padding(.padding(.extraLarge))
                .ignoresSafeArea()
                .background(.black.opacity(0.02))
            }
        }
        .animation(.easeOut, value: item.wrappedValue)
    }
    
    func refdsToast<Alert>(item: Binding<Alert?>) -> some View where Alert: RefdsAlert {
        ZStack {
            self
            if let viewData = item.wrappedValue {
                VStack {
                    Spacer()
                    RefdsToast(
                        icon: viewData.icon,
                        title: viewData.title,
                        message: viewData.message ?? "",
                        action: { item.wrappedValue = nil }
                    )
                    .refdsScaleEffect()
                }
                .ignoresSafeArea()
                .padding(.padding(.medium))
            }
        }
        .animation(.easeOut, value: item.wrappedValue)
    }
    
    func refdsDismissesKeyboad() -> some View {
        self
            .scrollDismissesKeyboard(.immediately)
            .background {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                    }
                }
                .ignoresSafeArea()
                .onTapGesture {
                    #if os(macOS)
                    #else
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                    #endif
                }
            }
    }
    
    func refdsTag(
        color: Color = .secondary,
        cornerRadius: CGFloat = 3
    ) -> some View {
        self
            .padding(3)
            .padding(.horizontal, 3)
            .if(color == .secondary) {
                $0.refdsBackground(with: .secondaryBackground)
            }
            .if(color != .secondary) {
                $0.background(color.opacity(0.2))
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
    }
    
    @ViewBuilder
    func refdsSafari(url: Binding<URL?>) -> some View {
        #if os(iOS)
        fullScreenCover(item: url) { url in
            RefdsSafari(url: url)
                .ignoresSafeArea()
        }
        #endif
    }
    
    @ViewBuilder
    func refdsRedacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
    
    @ViewBuilder
    func refdsShareText(item: Binding<String?>) -> some View {
        #if os(iOS)
        sheet(item: item) { item in
            RefdsShareRepresentable(items: [item])
                .presentationDetents([.medium, .large])
        }
        #endif
    }
    
    @ViewBuilder
    func refdsShare(item: Binding<URL?>) -> some View {
        #if os(iOS)
        sheet(item: item) { item in
            RefdsShareRepresentable(items: [item])
                .presentationDetents([.medium, .large])
        }
        #endif
    }
    
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition { transform(self) }
        else { self }
    }
    
    @ViewBuilder
    func `if`<Value, Content: View>(
        _ value: Value?,
        transform: (Self, Value) -> Content
    ) -> some View {
        if let value = value { transform(self, value) }
        else { self }
    }
}
