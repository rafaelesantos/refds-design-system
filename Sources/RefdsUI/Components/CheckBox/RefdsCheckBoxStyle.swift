import SwiftUI

public struct RefdsCheckBoxStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .padding(.medium)) {
            RefdsButton {
                withAnimation { configuration.isOn.toggle() }
            } label: {
                RefdsIcon(
                    configuration.isOn ? .checkmarkCircleFill : .circle,
                    color: .accentColor
                )
            }
            
            configuration.label
            
            Spacer(minLength: .zero)
        }
    }
}

public extension ToggleStyle where Self == RefdsCheckBoxStyle {
    static var checkmark: RefdsCheckBoxStyle {
        RefdsCheckBoxStyle()
    }
}
