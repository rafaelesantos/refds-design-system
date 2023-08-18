import SwiftUI
import RefdsCore

@available(iOS 16.4, *)
public struct RefdsMenu<Content: View, Label: View>: View {
    @ViewBuilder private let content: () -> Content
    @ViewBuilder private let label: () -> Label
    @State private var selection: Bool = false
    
    public init(content: @escaping () -> Content, label: @escaping () -> Label) {
        self.content = content
        self.label = label
    }

    public var body: some View {
        RefdsButton {
            withAnimation { selection.toggle() }
        } label: {
            label()
        }
        .popover(isPresented: $selection) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    content()
                }
                .padding([.horizontal])
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 5)
            .presentationCompactAdaptation(.popover)
        }
    }
}

@available(iOS 16.4, *)
struct RefdsMenu_Previews: PreviewProvider {
    static var previews: some View {
        RefdsMenu {
            ForEach(Array(0 ... 5), id: \.self) { _ in
                HStack {
                    VStack(alignment: .leading) {
                        RefdsText(.randomWord)
                        RefdsText(.randomWord, style: .footnote, color: .secondary)
                    }
                    Spacer()
                }
            }
        } label: { RefdsText("Menu PopOver") }
    }
}
