import SwiftUI

public struct RefdsAlertView: View {
    private let image: (() -> any View)?
    private let title: String?
    private let message: String?
    private let content: (() -> any View)?
    private let actions: [RefdsAlertViewAction]?
    private let dismiss: () -> Void
    
    private let timer = Timer.publish(every: 5, on: .current, in: .common).autoconnect()
    
    public init(
        image: (() -> any View)? = nil,
        title: String? = nil,
        message: String? = nil,
        content: (() -> any View)? = nil,
        actions: [RefdsAlertViewAction]?,
        dismiss: @escaping () -> Void
    ) {
        self.image = image
        self.title = title
        self.message = message
        self.content = content
        self.actions = actions
        self.dismiss = dismiss
    }
    
    private var hasAction: Bool {
        actions?.isEmpty != false
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            if hasAction {
                HStack {
                    Spacer(minLength: .zero)
                    RefdsButton { makeAction() } label: {
                        RefdsIcon(
                            .xmarkCircleFill,
                            color: .secondary,
                            style: .title3,
                            renderingMode: .hierarchical
                        )
                    }
                }
                .padding(-.padding(.small))
            }
            
            VStack(spacing: .padding(.medium)) {
                if let image = image {
                    AnyView(image())
                }
                
                VStack(spacing: .padding(.medium)) {
                    if let title = title {
                        RefdsText(
                            title,
                            style: .title3,
                            weight: .bold
                        )
                    }
                    
                    if let message = message {
                        RefdsText(
                            message,
                            style: .body,
                            color: .secondary,
                            alignment: .center
                        )
                    }
                }
                .padding(.horizontal, .padding(.medium))
                
                if let content = content {
                    AnyView(content())
                }
                
                makeActionView()
            }
        }
        .refdsCard(padding: .extraLarge)
        .onReceive(timer) { _ in
            if hasAction { makeAction() }
        }
    }
    
    @ViewBuilder
    private func makeActionView() -> some View {
        if let actions = actions, !actions.isEmpty {
            VStack(spacing: .padding(.extraSmall)) {
                ForEach(actions.indices, id: \.self) { index in
                    let action = actions[index]
                    let background = getButtonBackground(actionStyle: action.style)
                    let textColor = getButtonTextColor(actionStyle: action.style)
                    let style = getButtonStyle(actionStyle: action.style)
                    RefdsButton(
                        action.title,
                        backGroundColor: background,
                        textColor: textColor,
                        style: style,
                        action: { makeAction(action) }
                    )
                }
            }
            .padding(.top, .padding(.large))
            .padding(.horizontal, .padding(.medium))
        }
    }
    
    private func getButtonStyle(actionStyle: RefdsAlertViewActionStyle) -> RefdsButton.Style {
        switch actionStyle {
        case .done, .destructive: return .primary
        case .default: return .secondary
        case .custom: return .secondary
        }
    }
    
    private func getButtonBackground(actionStyle: RefdsAlertViewActionStyle) -> Color {
        switch actionStyle {
        case .done: return .accentColor
        case .destructive: return .red
        case .default: return .placeholder
        case .custom(let backgroundColor, _): return backgroundColor
        }
    }
    
    private func getButtonTextColor(actionStyle: RefdsAlertViewActionStyle) -> Color {
        switch actionStyle {
        case .done: return .white
        case .destructive: return .white
        case .default: return .primary
        case .custom(_, let textColor): return textColor
        }
    }
    
    private func makeAction(_ action: RefdsAlertViewAction? = nil) {
        withAnimation {
            action?.action()
            dismiss()
        }
    }
}

#Preview {
    struct ContainerView: View {
        @State private var item: RefdsAlertViewData?
        
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsButton {
                    let done = RefdsAlertViewAction(style: .done, title: .someWord()) {}
                    let back = RefdsAlertViewAction(style: .default, title: .someWord()) {}
                    item = .init(
                        title: .someWord(),
                        message: .someParagraph(),
                        actions: [done, back])
                } label: {
                    RefdsText(.someWord())
                }
            }
            .padding(.padding(.large))
            .refdsAlert(item: $item)
        }
    }
    return ContainerView()
}
