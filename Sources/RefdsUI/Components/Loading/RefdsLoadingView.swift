import SwiftUI

public struct RefdsLoadingView: View {
    @State private var isRotating = false
    
    private let color: RefdsColor
    private let minLineWidth: CGFloat = 2
    
    private func lineWidth(size: CGFloat) -> CGFloat {
        max(minLineWidth, size / 4)
    }
    
    public init(color: RefdsColor = .accentColor) {
        self.color = color
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(color.opacity(0.5))
                .rotationEffect(Angle(degrees: isRotating ? 0 : 360))
                .animation(.linear(duration: 0.5).repeatForever(autoreverses: false), value: isRotating)
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                .animation(.linear(duration: 0.5).repeatForever(autoreverses: false), value: isRotating)
                .onAppear { isRotating = true }
        }
        .frame(width: 20, height: 20)
    }
}

struct RefdsLoadingViewModifier: ViewModifier {
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .center) {
            if show { RefdsLoadingView() }
        }
    }
}

#Preview {
    VStack {
        Spacer()
    }
    .refdsLoading(show: .constant(true))
}
