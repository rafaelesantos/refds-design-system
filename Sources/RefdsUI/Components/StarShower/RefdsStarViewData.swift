import Foundation
import SwiftUI

public struct RefdsStarViewData {
    public var size: CGFloat
    public var position: CGPoint
    public var velocity: CGFloat
    public var color: Color
    
    public init(
        size: CGFloat,
        position: CGPoint,
        velocity: CGFloat,
        color: Color
    ) {
        self.size = size
        self.position = position
        self.velocity = velocity
        self.color = color
    }
}
