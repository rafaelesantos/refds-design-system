import SwiftUI

public struct RefdsSection<Content: View, Header: View, Footer: View>: View {
    private let content: () -> Content
    private let header: () -> Header
    private let footer: () -> Footer
    
    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    @ViewBuilder
    public var body: some View {
        #if os(iOS)
        Section {
           content()
        } header: {
            header()
        } footer: {
            footer()
        }
        #elseif os(macOS)
        VStack(alignment: .leading) {
            HStack { Spacer() }
            header()
                .textCase(.uppercase)
                .padding(.horizontal)
            if Content.self != EmptyView.self {
                GroupBox {
                    content()
                        .padding(.padding(.extraSmall))
                }
            }
            footer()
                .padding(.horizontal)
        }
        .padding()
        #endif
    }
}

#Preview {
    ScrollView {
        RefdsSection {
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
