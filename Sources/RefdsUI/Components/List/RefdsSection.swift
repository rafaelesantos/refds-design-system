import SwiftUI

public struct RefdsSection<Header: View, Footer: View>: View {
    private let content: (() -> any View)?
    private let header: () -> Header
    private let footer: () -> Footer
    
    public init(
        content: (() -> any View)?,
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
        #else
        VStack(alignment: .leading) {
            HStack { Spacer() }
            header()
                .textCase(.uppercase)
                .padding(.horizontal)
            if let content = content {
                GroupBox {
                    AnyView(content())
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
        RefdsSection(content: nil, header: {
            RefdsText(.someWord(), style: .footnote, color: .secondary)
        })
        
        RefdsSection {
            RefdsText(.someParagraph())
        } header: {
            RefdsText(.someWord(), style: .footnote, color: .secondary)
        }
    }
    .listStyle(.plain)
}
