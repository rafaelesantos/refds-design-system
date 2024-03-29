import SwiftUI

public struct RefdsToast: View {
    private let icon: (() -> any View)?
    private let title: String?
    private let message: String
    private let action: () -> Void
    private let timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    
    public init(
        icon: (() -> any View)? = nil,
        title: String? = nil,
        message: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: .padding(.small)) {
            if let icon = icon {
                AnyView(icon())
            }
            
            VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                if let title = title {
                    RefdsText(
                        title,
                        weight: .bold
                    )
                }
                RefdsText(
                    message,
                    style: .footnote,
                    color: .secondary
                )
            }
            
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
        .refdsCard()
        .onReceive(timer) { _ in
            makeAction()
        }
    }
    
    private func makeAction() {
        withAnimation { action() }
    }
}

#Preview {
    struct ContainerView: View {
        @State private var item: RefdsToastViewData?
        
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsButton {
                    item = .init(message: .someParagraph())
                } label: {
                    RefdsText(.someWord())
                }
            }
            .padding(.padding(.large))
            .refdsToast(item: $item)
        }
    }
    return ContainerView()
}
