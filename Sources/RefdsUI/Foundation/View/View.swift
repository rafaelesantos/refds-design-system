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
    func refdsTextField(state: RefdsTextFieldState?) -> some View {
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
    
    func refdsCard(padding: CGFloat.Padding = .medium) -> some View {
        self
            .padding(.padding(padding))
            .refdsSecondaryBackground()
            .cornerRadius(.cornerRadius)
            .shadow(color: .black.opacity(0.15), radius: .cornerRadius)
    }
    
    func refdsLoading(_ isLoading: Bool) -> some View {
        ZStack(alignment: .center) {
            self
            if isLoading {
                RefdsLoadingView()
            }
        }
    }
    
    
    func refdsSkeleton(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
    
    func refdsAlert(viewData: Binding<RefdsAlert.ViewData?>) -> some View {
        self.modifier(RefdsAlertModifier(alert: viewData))
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
