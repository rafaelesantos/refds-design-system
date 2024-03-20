import SwiftUI

public extension View {
    @ViewBuilder
    func refdsSkeleton(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
    
    func refdsAlert(viewData: Binding<RefdsAlert.ViewData?>) -> some View {
        self.modifier(RefdsAlertModifier(alert: viewData))
    }
    
    func refdsCard(withShadow: Bool = true) -> some View {
        self.modifier(RefdsCard(withShadow: withShadow))
    }
    
    @ViewBuilder
    func refdsLoading(show: Binding<Bool>) -> some View {
        modifier(RefdsLoadingViewModifier(show: show))
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
