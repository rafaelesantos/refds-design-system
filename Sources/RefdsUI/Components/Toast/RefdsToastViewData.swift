import SwiftUI

public struct RefdsToastViewData: Equatable {
    public let id: UUID
    public let icon: (() -> any View)?
    public let title: String?
    public let message: String
    
    public init(
        icon: (() -> any View)? = nil,
        title: String? = nil,
        message: String
    ) {
        self.id = .init()
        self.icon = icon
        self.title = title
        self.message = message
    }
    
    public static func == (lhs: RefdsToastViewData, rhs: RefdsToastViewData) -> Bool {
        lhs.id == rhs.id
    }
}
