//
//  RefdsAlert.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import SwiftUI

public struct RefdsAlert: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let style: Style
    private let withBackground: Bool
    private let primaryAction: Action?
    private let secondaryAction: Action?
    
    public init(style: Style, withBackground: Bool = false, primaryAction: Action? = nil, secondaryAction: Action? = nil) {
        self.style = style
        self.withBackground = withBackground
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public var body: some View {
        if withBackground {
            styles.refdsCard()
        } else { styles }
    }
    
    @ViewBuilder
    private var styles: some View {
        switch style {
        case let .basic(style, title, message): basic(style, title: title, message: message)
        case let .inline(style, title): inline(style, title: title)
        }
    }
    
    private func basic(_ style: Style.BasicType, title: String, message: String?) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                Spacer()
                RefdsText(title, style: .title3, weight: .bold)
                Spacer()
            }
            
            if let message = message {
                HStack {
                    Spacer()
                    RefdsText(message, style: .subheadline, alignment: .center)
                        .padding(.bottom, 15)
                    Spacer()
                }
            }
            
            HStack(spacing: 5) {
                if let primaryAction = primaryAction, !primaryAction.title.isEmpty {
                    RefdsButton(primaryAction.title, color: style.color, style: .primary, font: .subheadline, action: primaryAction.action)
                }
                
                if let secondaryAction = secondaryAction, !secondaryAction.title.isEmpty {
                    RefdsButton(secondaryAction.title, color: style.color, style: .secondary, font: .subheadline, action: secondaryAction.action)
                }
            }
        }
    }
    
    private func inline(_ style: Style.BasicType, title: String) -> some View {
        HStack(spacing: 15) {
            if let icon = style.icon {
                RefdsIcon(symbol: icon, color: style.color, renderingMode: .hierarchical)
            }
            RefdsText(title, style: .body)
            Spacer()
            if let primaryAction = primaryAction, !primaryAction.title.isEmpty {
                RefdsButton(primaryAction.title, color: style.color, style: .primary, font: .footnote, maxSize: false, action: primaryAction.action)
            }
        }
    }
}

public extension RefdsAlert {
    struct ViewData: Equatable {
        public let style: Style
        public let primaryAction: Action?
        public let secondaryAction: Action?
        
        public init(style: Style, primaryAction: Action? = nil, secondaryAction: Action? = nil) {
            self.style = style
            self.primaryAction = primaryAction
            self.secondaryAction = secondaryAction
        }
        
        public static func == (lhs: RefdsAlert.ViewData, rhs: RefdsAlert.ViewData) -> Bool {
            lhs.style.id == rhs.style.id
        }
    }
}

public extension RefdsAlert {
    struct Action {
        let title: String
        let action: (() -> Void)?
        
        public init(title: String, action: (() -> Void)? = nil) {
            self.title = title
            self.action = action
        }
    }
    
    enum Style: Identifiable, Equatable {
        case basic(BasicType, String, String?)
        case inline(BasicType, String)
        
        public var id: String {
            switch self {
            case let .basic(type, title, message): return "\(type.rawValue).\(title).\(message ?? "")"
            case let .inline(type, title): return "\(type.rawValue).\(title)"
            }
        }
        
        public var duration: Double? {
            switch self {
            case let .basic(type, _, _): return type.duration
            case let .inline(type, _): return type.duration
            }
        }
        
        public var basicType: BasicType {
            switch self {
            case let .basic(type, _, _): return type
            case let .inline(type, _): return type
            }
        }
        
        public var title: String {
            switch self {
            case let .basic(_, title, _): return title
            case let .inline(_, title): return title
            }
        }
        
        public var message: String? {
            switch self {
            case let .basic(_, _, message): return message
            case .inline(_, _): return nil
            }
        }
        
        public enum BasicType: String {
            case info
            case success
            case warning
            case critical
            case none
            
            public var color: RefdsColor {
                switch self {
                case .info: return .blue
                case .success: return .green
                case .warning: return .orange
                case .critical: return .red
                case .none: return .accentColor
                }
            }
            
            public var icon: RefdsIconSymbol? {
                switch self {
                case .info: return .infoCircleFill
                case .success: return .checkmarkCircleFill
                case .warning: return .exclamationmarkCircleFill
                case .critical: return .exclamationmarkCircleFill
                case .none: return nil
                }
            }
            
            public var duration: Double? {
                switch self {
                case .none: return 5
                default: return nil
                }
            }
        }
    }
}

struct RefdsAlert_Previews: PreviewProvider {
    static let title: String = "Alert Title"
    static let message: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vestibulum dignissim tellus eu viverra. In in quam mauris.\n\nMauris arcu quam, maximus iaculis nibh a, vehicula aliquet leo. Nullam non tempor purus, ut maximus sem. Sed vel erat et dolor scelerisque tincidunt eu quis ex."
    static let primaryAction = RefdsAlert.Action(title: "Primary")
    static let secondaryAction = RefdsAlert.Action(title: "Secondary")
    static var previews: some View {
        Group {
            List {
                Section {
                    RefdsAlert(style: .basic(.info, title, message))
                    RefdsAlert(style: .basic(.info, title, message), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.info, title, message), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.info, title, message), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.success, title, message))
                    RefdsAlert(style: .basic(.success, title, message), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.success, title, message), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.success, title, message), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.warning, title, message))
                    RefdsAlert(style: .basic(.warning, title, message), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.warning, title, message), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.warning, title, message), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.critical, title, message))
                    RefdsAlert(style: .basic(.critical, title, message), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.critical, title, message), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.critical, title, message), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.none, title, message))
                    RefdsAlert(style: .basic(.none, title, message), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.none, title, message), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.none, title, message), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
            }
        }
        
        Group {
            List {
                Section {
                    RefdsAlert(style: .inline(.info, title))
                    RefdsAlert(style: .inline(.info, title), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.success, title))
                    RefdsAlert(style: .inline(.success, title), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.warning, title))
                    RefdsAlert(style: .inline(.warning, title), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.critical, title))
                    RefdsAlert(style: .inline(.critical, title), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.none, title))
                    RefdsAlert(style: .inline(.none, title), primaryAction: primaryAction)
                }
            }
        }
        
        Group {
            VStack(spacing: 30) {
                Spacer()
                RefdsAlert(style: .inline(.none, title), withBackground: true)
                RefdsAlert(style: .inline(.info, title), withBackground: true, primaryAction: primaryAction)
                RefdsAlert(style: .basic(.info, title, message), withBackground: true, primaryAction: primaryAction, secondaryAction: secondaryAction)
                Spacer()
            }
            .padding()
        }
    }
}
