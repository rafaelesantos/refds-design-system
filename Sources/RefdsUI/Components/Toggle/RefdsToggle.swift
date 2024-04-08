import SwiftUI

public struct RefdsToggle: View {
    @Binding private var isOn: Bool
    private let content: (() -> any View)?
    
    public init(
        isOn: Binding<Bool>,
        content: (() -> any View)? = nil
    ) {
        self._isOn = isOn
        self.content = content
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            if let content = content {
                AnyView(content())
            }
        }
        #if os(tvOS)
        .toggleStyle(.automatic)
        #else
        .toggleStyle(.switch)
        #endif
        .tint(RefdsUI.shared.accentColor)
    }
}

#Preview {
    struct ContainerView: View {
        @State private var isOn = false
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsToggle(isOn: $isOn) {
                    VStack(alignment: .leading) {
                        RefdsText(.someWord(), style: .title3, weight: .bold)
                        RefdsText(.someParagraph(), color: .secondary)
                    }
                }
            }
            .padding(.padding(.large))
        }
    }
    return ContainerView()
}
