import SwiftUI

public struct RefdsStarShower: View {
    @State private var starsViewData: [RefdsStarViewData] = []
    
    private let timer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
        .ignoresSafeArea()
    }
    
    private func makeStars() {
        for _ in 1 ... 200 {
            let position = CGPoint(x: .random(in: 0 ... screenWidth), y: .random(in: 0 ... screenHeight))
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
            if star.position.x > screenWidth {
                starsViewData[index].position = .init(x: .random(in: 0 ... screenWidth / 100), y: .random(in: 0 ... screenHeight))
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
        return colors.randomElement()!.opacity(.random(in: 0.5 ... 1))
    }
}

#Preview {
    RefdsStarShower()
}
