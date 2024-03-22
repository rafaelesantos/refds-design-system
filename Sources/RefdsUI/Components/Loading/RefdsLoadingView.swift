import SwiftUI

public struct RefdsLoadingView: View {
    @State private var isRotating = false
    
    private let color: RefdsColor
    
    private var normalDegrees: Double { isRotating ? 0 : 360 }
    private var reverseDegrees: Double { isRotating ? 360 : 0 }
    private var circleAnimation: Animation {
        .linear(duration: 0.5)
        .repeatForever(autoreverses: false)
    }
    
    public init(color: RefdsColor = .accentColor) {
        self.color = color
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            circleSectionView(color: color.opacity(0.5), isReverse: true)
            circleSectionView(color: color)
        }
        .onAppear { isRotating = true }
        .frame(width: 20, height: 20)
    }
    
    private func circleSectionView(
        color: RefdsColor,
        isReverse: Bool = false
    ) -> some View {
        Circle()
            .trim(from: 0.5, to: 0.75)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: isReverse ? reverseDegrees : normalDegrees))
            .animation(circleAnimation, value: isRotating)
    }
}

#Preview {
    struct ContainerView: View {
        @State private var isLoading = false
        
        var body: some View {
            Group {
                if !isLoading { contentView }
            }
            .refdsLoading(isLoading)
            .onAppear { changeLoadingState() }
        }
        
        private var contentView: some View {
            List {
                ForEach(1 ... 20, id: \.self) { _ in
                    HStack(spacing: .padding(.large)) {
                        RefdsIcon(.random, color: .random, size: 30)
                        VStack(alignment: .leading, spacing: .padding(.small)) {
                            RefdsText(.someWord(), weight: .bold)
                            RefdsText(.someParagraph(), style: .footnote, color: .placeholder)
                        }
                    }
                }
            }
        }
        
        private func changeLoadingState() {
            withAnimation { isLoading.toggle() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.changeLoadingState() }
        }
    }
    return ContainerView()
}
