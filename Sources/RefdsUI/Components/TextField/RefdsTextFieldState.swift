import Foundation

public enum RefdsTextFieldState {
    case error(String)
    case warning(String)
    case success(String)
    case detail(String)
    
    public var color: RefdsColor {
        switch self {
        case .error: return .red
        case .warning: return .orange
        case .success: return .green
        case .detail: return .secondary
        }
    }
    
    public var description: String {
        switch self {
        case let .error(description): return description
        case let .warning(description): return description
        case let .success(description): return description
        case let .detail(description): return description
        }
    }
}
