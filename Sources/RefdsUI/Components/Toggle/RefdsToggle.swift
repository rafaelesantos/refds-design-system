import SwiftUI

public struct RefdsToggle<Style: ToggleStyle>: View {
    @Binding private var isOn: Bool
    private let style: Style
    private let content: (() -> any View)?
    
    public init(
        isOn: Binding<Bool>,
        style: Style = .automatic,
        content: (() -> any View)? = nil
    ) {
        self._isOn = isOn
        self.style = style
        self.content = content
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            if let content = content {
                AnyView(content())
            }
        }
        #if os(tvOS)
        .toggleStyle(.switch)
        #else
        .toggleStyle(style)
        #endif
        .tint(.accentColor)
    }
}

#Preview {
    struct ContainerView: View {
        @State private var isOn = false
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsToggle(isOn: $isOn, style: .checkmark) {
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
