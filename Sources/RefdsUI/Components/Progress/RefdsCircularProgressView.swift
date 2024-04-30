import SwiftUI
import RefdsShared

public struct RefdsCircularProgressView: View {
    @State private var value: Double = 0
    @State private var progressColor: Color = .secondary.opacity(0.7)
    
    private let progress: Double
    private let size: CGFloat
    private let color: Color
    private let scale: CGFloat
    
    public init(
        _ progress: Double,
        size: CGFloat = 100,
        color: Color = .accentColor,
        scale: CGFloat = 0.1
    ) {
        self.progress = progress
        self.size = size
        self.color = color
        self.scale = scale
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: size * scale, lineCap: .round, lineJoin: .round))
                .opacity(0.2)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.3, to: value)
                .stroke(style: StrokeStyle(lineWidth: size * scale, lineCap: .round, lineJoin: .round))
                .fill(AngularGradient(gradient: Gradient(stops: [
                    .init(color: Color.green, location: 0.5),
                    .init(color: Color.yellow, location: 0.7),
                    .init(color: Color.orange, location: 0.8),
                    .init(color: Color.red, location: 0.9)
                ]), center: .center))
                .rotationEffect(.degrees(54.5))
                .animation(.easeInOut(duration: 1), value: value)
            
            VStack(spacing: .zero) {
                Spacer(minLength: .zero)
                RefdsText(progress.percent(), style: .callout, weight: .bold)
                RefdsText(progress.riskDescription, style: .footnote, color: .secondary)
                Spacer(minLength: .zero)
            }
            .frame(width: size, height: size)
        }
        .frame(width: size)
        .padding(.bottom, -(size * 0.2))
        .onAppear { reload() }
        .onChange(of: progress) { reload() }
    }
    
    private func reload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            progressColor = color
            let progress = progress * 0.6
            value = (progress + 0.3) > 0.9 ? 0.9 : (progress + 0.3)
        }
    }
}

#Preview {
    RefdsCircularProgressView(1.5)
}
