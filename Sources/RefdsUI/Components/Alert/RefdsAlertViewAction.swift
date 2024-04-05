import SwiftUI

public struct RefdsAlertViewAction {
    public var style: RefdsAlertViewActionStyle
    public var title: String
    public var action: () -> Void
    
    public init(
        style: RefdsAlertViewActionStyle,
        title: String,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.action = action
    }
}

public enum RefdsAlertViewActionStyle {
    case done
    case destructive
    case `default`
    case custom(backgroundColor: Color, textColor: Color)
}
