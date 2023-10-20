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
    
    private var styles: some View {
        Group {
            switch style {
            case let .basic(style, title, message, imageURL): basic(style, title: title, message: message, imageURL: imageURL)
            case let .inline(style, title, icon): inline(style, title: title, icon: icon)
            }
        }
        .buttonStyle(.borderless)
    }
    
    private func basic(_ style: Style.BasicType, title: String, message: String?, imageURL: String?) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                HStack(spacing: 15) {
                    Spacer()
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit().frame(height: 180)
                    } placeholder: {
                        RefdsLoadingView().padding()
                    }
                    Spacer()
                }
            }
            HStack(spacing: 15) {
                Spacer()
                RefdsText(title, style: .title3, weight: .bold)
                Spacer()
            }
            
            Divider().padding(10).padding(.horizontal)
            
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
        .padding()
    }
    
    private func inline(_ style: Style.BasicType, title: String, icon: RefdsIconSymbol) -> some View {
        HStack(spacing: 15) {
            if let icon = style.icon {
                RefdsIcon(symbol: icon, color: style.color, renderingMode: .hierarchical)
            }
            RefdsText(title, style: .body)
            Spacer()
            if let primaryAction = primaryAction, !primaryAction.title.isEmpty {
                RefdsButton(action: primaryAction.action) {
                    RefdsIcon(symbol: icon, color: .white, size: 14)
                        .padding(5)
                        .frame(width: 26, height: 26)
                        .background(style.color)
                        .cornerRadius(13)
                }
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
        case basic(BasicType, String, String?, String?)
        case inline(BasicType, String, RefdsIconSymbol)
        
        public var id: String {
            switch self {
            case let .basic(type, title, message, _): return "\(type.rawValue).\(title).\(message ?? "")"
            case let .inline(type, title, _): return "\(type.rawValue).\(title)"
            }
        }
        
        public var duration: Double? {
            switch self {
            case let .basic(type, _, _, _): return type.duration
            case let .inline(type, _, _): return type.duration
            }
        }
        
        public var basicType: BasicType {
            switch self {
            case let .basic(type, _, _, _): return type
            case let .inline(type, _, _): return type
            }
        }
        
        public var title: String {
            switch self {
            case let .basic(_, title, _, _): return title
            case let .inline(_, title, _): return title
            }
        }
        
        public var message: String? {
            switch self {
            case let .basic(_, _, message, _): return message
            case .inline(_, _, _): return nil
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
                    RefdsAlert(style: .basic(.info, title, message, nil))
                    RefdsAlert(style: .basic(.info, title, message, nil), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.info, title, message, nil), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.info, title, message, "https://firelinks.io/assets/images/resource/illustration-4-ai.png"), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.success, title, message, nil))
                    RefdsAlert(style: .basic(.success, title, message, nil), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.success, title, message, nil), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.success, title, message, nil), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.warning, title, message, nil))
                    RefdsAlert(style: .basic(.warning, title, message, nil), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.warning, title, message, nil), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.warning, title, message, nil), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.critical, title, message, nil))
                    RefdsAlert(style: .basic(.critical, title, message, nil), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.critical, title, message, nil), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.critical, title, message, nil), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
                
                Section {
                    RefdsAlert(style: .basic(.none, title, message, nil))
                    RefdsAlert(style: .basic(.none, title, message, nil), primaryAction: primaryAction)
                    RefdsAlert(style: .basic(.none, title, message, nil), secondaryAction: secondaryAction)
                    RefdsAlert(style: .basic(.none, title, message, nil), primaryAction: primaryAction, secondaryAction: secondaryAction)
                }
            }
        }
        
        Group {
            List {
                Section {
                    RefdsAlert(style: .inline(.info, title, .checkmark))
                    RefdsAlert(style: .inline(.info, title, .checkmark), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.success, title, .checkmark))
                    RefdsAlert(style: .inline(.success, title, .checkmark), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.warning, title, .checkmark))
                    RefdsAlert(style: .inline(.warning, title, .checkmark), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.critical, title, .checkmark))
                    RefdsAlert(style: .inline(.critical, title, .checkmark), primaryAction: primaryAction)
                }
                
                Section {
                    RefdsAlert(style: .inline(.none, title, .checkmark))
                    RefdsAlert(style: .inline(.none, title, .checkmark), primaryAction: primaryAction)
                }
            }
        }
        
        Group {
            VStack(spacing: 30) {
                Spacer()
                RefdsAlert(style: .inline(.none, title, .checkmark), withBackground: true)
                RefdsAlert(style: .inline(.info, title, .checkmark), withBackground: true, primaryAction: primaryAction)
                RefdsAlert(style: .basic(.info, title, message, "https://firelinks.io/assets/images/resource/illustration-4-ai.png"), withBackground: true, primaryAction: primaryAction, secondaryAction: secondaryAction)
                Spacer()
            }
            .padding()
        }
    }
}
