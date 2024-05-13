import SwiftUI
import RefdsShared

public struct RefdsCircularProgressView: View {
    @State private var value: Double = 0
    
    private let progress: Double
    private let size: CGFloat
    private let color: Color
    private let scale: CGFloat
    private let hasAnimation: Bool
    private let progressAdapted: Double
    
    public init(
        _ progress: Double,
        size: CGFloat = 100,
        color: Color = .accentColor,
        scale: CGFloat = 0.1,
        hasAnimation: Bool = true
    ) {
        self.progress = progress
        self.size = size
        self.color = color
        self.scale = scale
        self.hasAnimation = hasAnimation
        let progressAdapted = progress * 0.6
        self.progressAdapted = (progressAdapted + 0.3) > 0.9 ? 0.9 : (progressAdapted + 0.3)
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: size * scale, lineCap: .round, lineJoin: .round))
                .opacity(0.2)
                .foregroundColor(Color.secondary.opacity(0.4))
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.3, to: hasAnimation ? value : progressAdapted)
                .stroke(style: StrokeStyle(lineWidth: size * scale, lineCap: .round, lineJoin: .round))
                .fill(progress.riskColor)
                .rotationEffect(.degrees(54.5))
                .animation(.easeInOut(duration: 1), value: value)
            
            VStack(spacing: .zero) {
                Spacer(minLength: .zero)
                RefdsText(progress.percent(), style: .system(size: size * 0.2), weight: .bold)
                RefdsText(
                    progress.riskDescription.uppercased(),
                    style: .system(size: size * 0.08),
                    color: progress.riskColor,
                    weight: .bold
                )
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
            value = progressAdapted
        }
    }
}

#Preview {
    RefdsCircularProgressView(1.5)
}
