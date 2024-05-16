import SwiftUI

public struct RefdsCheckBoxStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        
        RefdsButton {
            withAnimation { configuration.isOn.toggle() }
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIcon(
                    configuration.isOn ? .checkmarkCircleFill : .circle,
                    color: .accentColor,
                    size: 20
                )
                
                configuration.label
                
                Spacer(minLength: .zero)
            }
        }
    }
}

public extension ToggleStyle where Self == RefdsCheckBoxStyle {
    static var checkmark: RefdsCheckBoxStyle {
        RefdsCheckBoxStyle()
    }
}
