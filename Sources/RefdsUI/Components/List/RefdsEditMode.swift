// Documentation comments are copied from the official documentation for iOS.

import SwiftUI

#if os(macOS)

public enum EditMode {
    case active
    case inactive
    case transient
}

extension EditMode: Equatable {}
extension EditMode: Hashable {}

extension EditMode {
    public var isEditing: Bool {
        self != .inactive
    }
}

private struct EditModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<EditMode>?
}

extension EnvironmentValues {
    public var editMode: Binding<EditMode>? {
        get {
            self[EditModeEnvironmentKey.self]
        }
        set {
            self[EditModeEnvironmentKey.self] = newValue
        }
    }
}

#endif

extension Optional where Wrapped == Binding<EditMode> {
    public var isEditing: Bool {
        self?.wrappedValue.isEditing == true
    }
}

extension EditMode {
    public mutating func toggle() {
        switch self {
        case .inactive: self = .active
        case .active: self = .inactive
        case .transient: break
#if os(iOS)
        @unknown default: break
#endif
        }
    }
}
