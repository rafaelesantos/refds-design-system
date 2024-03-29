import SwiftUI

public struct RefdsScaleEffect: ViewModifier {
    @State private var scale: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: .center)
            .onAppear {
                withAnimation(.bouncy) { scale = 1 }
            }
    }
}
