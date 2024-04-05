import SwiftUI

public struct RefdsAlertViewData: Equatable {
    public let id: UUID
    public let image: (() -> any View)?
    public let title: String?
    public let message: String?
    public let content: (() -> any View)?
    public let actions: [RefdsAlertViewAction]?
    
    public init(
        image: (() -> any View)? = nil,
        title: String? = nil,
        message: String? = nil,
        actions: [RefdsAlertViewAction]?,
        content: (() -> any View)? = nil
    ) {
        self.id = .init()
        self.image = image
        self.title = title
        self.message = message
        self.actions = actions
        self.content = content
    }
    
    public static func == (lhs: RefdsAlertViewData, rhs: RefdsAlertViewData) -> Bool {
        lhs.id == rhs.id
    }
}
