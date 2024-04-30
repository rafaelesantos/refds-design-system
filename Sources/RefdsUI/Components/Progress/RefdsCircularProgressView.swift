import SwiftUI

public struct RefdsCircularProgressView: View {
    @State private var value: Double = 0
    
    private let progress: Double
    private let size: CGFloat
    private let color: Color
    
    public init(
        _ progress: Double,
        size: CGFloat = 30,
        color: Color = .accentColor
    ) {
        self.progress = progress
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.2),
                    lineWidth: size * 0.2
                )
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: size * 0.2,
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
    RefdsCircularProgressView(0.8)
}
