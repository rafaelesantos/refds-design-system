import SwiftUI
#if canImport(CoreMotion)
import CoreMotion
#endif

struct ParallaxMotionModifier: ViewModifier {
    @StateObject private var manager: MotionManager = MotionManager()
    private var magnitude: Double
    
    init(magnitude: Double = 15) {
        self.magnitude = magnitude
    }
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(magnitude), axis: (
                x: CGFloat(manager.roll),
                y: CGFloat(manager.pitch),
                z: 0.0
            ))
    }
}

public extension View {
    func refdsParallax(magnitude: Double = 15) -> some View {
        self.modifier(ParallaxMotionModifier(magnitude: magnitude))
    }
}

class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    #if os(iOS)
    private var manager: CMMotionManager
    #endif

    init() {
        #if os(iOS)
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1 / 60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll

            }
        }
        #endif
    }
}
