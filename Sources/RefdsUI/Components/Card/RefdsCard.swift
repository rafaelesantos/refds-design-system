import SwiftUI

public struct RefdsCard: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    private let withShadow: Bool
    
    public init(withShadow: Bool = true) {
        self.withShadow = withShadow
    }
    
    public func body(content: Content) -> some View {
        if withShadow {
            Group {
                content.padding()
            }
            .background(Color.secondaryBackground(scheme: scheme))
            .cornerRadius(.cornerRadius)
            .shadow(color: .black.opacity(0.15), radius: 15)
            .padding(.all, 2)
        } else {
            Group {
                content.padding()
            }
            .background(Color.secondaryBackground(scheme: scheme))
            .cornerRadius(.cornerRadius)
        }
    }
}

#Preview {
    HStack {
        RefdsIcon(.infinity)
        RefdsText("Infinity")
    }
    .refdsCard()
}
