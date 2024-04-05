import SwiftUI

public extension View {
    func refdsBorder(
        color: RefdsColor = .placeholder,
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
        hasShadow: Bool = true
    ) -> some View {
        self
            .padding(.padding(padding))
            .refdsSecondaryBackground()
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
    
    func refdsToast(item: Binding<RefdsToastViewData?>) -> some View {
        ZStack {
            self
            if let viewData = item.wrappedValue {
                VStack {
                    Spacer()
                    RefdsToast(
                        icon: viewData.icon,
                        title: viewData.title,
                        message: viewData.message,
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
