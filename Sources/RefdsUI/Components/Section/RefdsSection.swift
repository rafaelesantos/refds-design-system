import SwiftUI

public struct RefdsSection: View {
    private let content: () -> any View
    private let header: () -> any View
    private let footer: () -> any View
    
    public init(
        @ViewBuilder content: @escaping () -> some View,
        @ViewBuilder header: @escaping () -> some View = { EmptyView() },
        @ViewBuilder footer: @escaping () -> some View = { EmptyView() }
    ) {
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    @ViewBuilder
    public var body: some View {
        #if os(iOS)
        Section {
           AnyView(content())
        } header: {
            AnyView(header())
        } footer: {
            AnyView(footer())
        }
        #else
        VStack(alignment: .leading) {
            AnyView(header())
                .textCase(.uppercase)
                .padding(.horizontal)
            GroupBox {
                HStack(spacing: .zero) { Spacer() }
                    .frame(height: 0)
                AnyView(content())
                    .padding(.padding(.extraSmall))
            }
            AnyView(footer())
                .padding(.horizontal)
        }
        .padding()
        #endif
    }
}

#Preview {
    ScrollView {
        RefdsSection {
            RefdsText(.someParagraph())
        } header: {
            RefdsText(.someWord(), style: .footnote, color: .secondary)
        }
        
        RefdsSection {
            RefdsText(.someParagraph())
        } header: {
            RefdsText(.someWord(), style: .footnote, color: .secondary)
        }
    }
    .listStyle(.plain)
}
