import Foundation

public struct RefdsStarViewData {
    public var size: CGFloat
    public var position: CGPoint
    public var velocity: CGFloat
    public var color: RefdsColor
    
    public init(
        size: CGFloat,
        position: CGPoint,
        velocity: CGFloat,
        color: RefdsColor
    ) {
        self.size = size
        self.position = position
        self.velocity = velocity
        self.color = color
    }
}
