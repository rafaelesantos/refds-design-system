import SwiftUI

public struct RefdsCircularProgressView: View {
    @State private var value: Double = 0
    
    private let progress: Double
    private let size: CGFloat
    private let color: Color
    private let scale: CGFloat
    
    public init(
        _ progress: Double,
        size: CGFloat = 30,
        color: Color = .accentColor,
        scale: CGFloat = 0.15
    ) {
        self.progress = progress
        self.size = size
        self.color = color
        self.scale = scale
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.2),
                    lineWidth: size * scale
                )
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: size * scale,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: value)
        }
        .frame(width: size, height: size)
        .onAppear { reload() }
        .onChange(of: progress) { reload() }
    }
    
    private func reload() {
        value = progress
    }
}

#Preview {
    RefdsCircularProgressView(0.8, size: 80)
}
