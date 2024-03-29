import SwiftUI

public struct RefdsStarShower: View {
    @State private var starsViewData: [RefdsStarViewData] = []
    
    private let timer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
    let galaxyWidth: CGFloat = UIScreen.main.bounds.width
    let galaxyHeight: CGFloat
    
    public init( galaxyHeight: CGFloat = UIScreen.main.bounds.height) {
        self.galaxyHeight = galaxyHeight
    }
    
    public var body: some View {
        Canvas { context, size in
            for star in starsViewData {
                let newContext = context
                let rect = CGRect(x: star.position.x, y: star.position.y, width: star.size, height: star.size)
                newContext.fill(Path(ellipseIn: rect), with: .color(star.color))
            }
        }
        .background(RefdsColor.black)
        .onAppear { makeStars() }
        .onReceive(timer) { _ in moveStars() }
        .frame(height: galaxyHeight)
    }
    
    private func makeStars() {
        for _ in 1 ... 200 {
            let position = CGPoint(x: .random(in: 0 ... galaxyWidth), y: .random(in: 0 ... galaxyHeight))
            let star = RefdsStarViewData(
                size: .random(in: 2 ... 5),
                position: position,
                velocity: .random(in: 1 ... 4),
                color: randomColorStar()
            )
            starsViewData += [star]
        }
    }
    
    private func moveStars() {
        for index in starsViewData.indices {
            let star = starsViewData[index]
            starsViewData[index].position.x += star.velocity
            if star.position.x > galaxyWidth {
                starsViewData[index].position = .init(x: .random(in: 0 ... galaxyWidth / 100), y: .random(in: 0 ... galaxyHeight))
            }
        }
    }
    
    func randomColorStar() -> RefdsColor {
        let colors: [RefdsColor] = [
            .white,
            .white,
            .white,
            .white,
            .white,
            .white,
            .white,
            .blue,
        ]
        return colors.randomElement()!.opacity(.random(in: 0.8 ... 1))
    }
}

#Preview {
    VStack {
        RefdsStarShower(galaxyHeight: 200)
            .clipShape(.rect(cornerRadius: .cornerRadius))
            .padding(.padding(.extraLarge))
    }
}
