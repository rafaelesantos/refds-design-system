import SwiftUI
import RefdsShared

public struct RefdsStarShower: View {
    @State private var starsViewData: [RefdsStarViewData] = []
    
    private let timer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
    private let edge: RefdsStarShowerEdge
    private let galaxyHeight: CGFloat
    private let backgroundColor: Color?
    
    public init(
        from edge: RefdsStarShowerEdge = .leading,
        galaxyHeight: CGFloat = 1000,
        backgroundColor: Color? = nil
    ) {
        self.edge = edge
        self.galaxyHeight = galaxyHeight
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                for star in starsViewData {
                    let newContext = context
                    let rect = CGRect(x: star.position.x, y: star.position.y, width: star.size, height: star.size)
                    newContext.fill(Path(ellipseIn: rect), with: .color(star.color))
                }
            }
            .if(backgroundColor, transform: { view, color in
                view.background(color.opacity(0.2))
            })
            .if(backgroundColor == nil, transform: { view in
                view.refdsBackground(with: .secondaryBackground)
            })
            .onAppear { makeStars(width: proxy.size.width) }
            .onReceive(timer) { _ in moveStars(width: proxy.size.width) }
            .frame(height: galaxyHeight)
        }
    }
    
    private func makeStars(width: CGFloat) {
        for _ in 1 ... 200 {
            let position = CGPoint(x: .random(in: 0 ... width), y: .random(in: 0 ... galaxyHeight))
            let star = RefdsStarViewData(
                size: .random(in: 2 ... 5),
                position: position,
                velocity: .random(in: 1 ... 4),
                color: randomColorStar()
            )
            starsViewData += [star]
        }
    }
    
    private func moveStars(width: CGFloat) {
        for index in starsViewData.indices {
            let star = starsViewData[index]
            switch edge {
            case .top:
                starsViewData[index].position.y += star.velocity
                if star.position.y > galaxyHeight {
                    starsViewData[index].position = .init(
                        x: .random(in: 0 ... width),
                        y: .random(in: 0 ... galaxyHeight / 100)
                    )
                }
                
            case .bottom:
                starsViewData[index].position.y -= star.velocity
                if star.position.y < 0 {
                    starsViewData[index].position = .init(
                        x: .random(in: 0 ... width),
                        y: .random(in: galaxyHeight / 1.1 ... galaxyHeight)
                    )
                }
                
            case .leading:
                starsViewData[index].position.x += star.velocity
                if star.position.x > width {
                    starsViewData[index].position = .init(
                        x: .random(in: 0 ... width / 100),
                        y: .random(in: 0 ... galaxyHeight)
                    )
                }
                
            case .trailing:
                starsViewData[index].position.x -= star.velocity
                if star.position.x < 0 {
                    starsViewData[index].position = .init(
                        x: .random(in: width / 1.1 ... width),
                        y: .random(in: 0 ... galaxyHeight)
                    )
                }
            }
        }
    }
    
    func randomColorStar() -> Color {
        let colors: [Color] = [
            .primary,
            .primary,
            .primary,
            .primary,
            .accentColor,
        ]
        return colors.randomElement()!.opacity(.random(in: 0.8 ... 1))
    }
}

#Preview {
    VStack {
        RefdsStarShower(from: .bottom, galaxyHeight: 200, backgroundColor: .accentColor)
            .refdsParallax()
            .padding(.padding(.extraLarge))
    }
}
