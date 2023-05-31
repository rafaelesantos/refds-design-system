//
//  RefdsSection.swift
//  
//
//  Created by Rafael Santos on 31/05/23.
//

import SwiftUI

public struct RefdsSection<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let proxy: GeometryProxy
    private let content: () -> Content
    private let headerDescription: String?
    private let footerDescription: String?
    private let header: (() -> any View)?
    private let footer: (() -> any View)?
    private let maxColumns: Int?
    
    public init(proxy: GeometryProxy, maxColumns: Int? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.proxy = proxy
        self.headerDescription = nil
        self.footerDescription = nil
        self.header = nil
        self.footer = nil
        self.content = content
        self.maxColumns = maxColumns
    }
    
    public init(proxy: GeometryProxy, maxColumns: Int? = nil, headerDescription: String? = nil, footerDescription: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.proxy = proxy
        self.headerDescription = headerDescription
        self.footerDescription = footerDescription
        self.header = nil
        self.footer = nil
        self.content = content
        self.maxColumns = maxColumns
    }
    
    public init(proxy: GeometryProxy, maxColumns: Int? = nil, header: (() -> any View)? = nil, footer: (() -> any View)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.proxy = proxy
        self.headerDescription = nil
        self.footerDescription = nil
        self.header = header
        self.footer = footer
        self.content = content
        self.maxColumns = maxColumns
    }
    
    public var body: some View {
        if isLargeScreen {
            macOSView
        } else {
            iOSView
        }
    }
    
    private var macOSView: some View  {
        VStack {
            macOSHeader
            LazyVGrid(columns: .columns(width: proxy.size.width, maxAmount: maxColumns)) {
                content().refdsCard()
            }.padding(.horizontal)
            macOSFooter
        }
        .padding()
    }
    
    @ViewBuilder
    private var macOSHeader: some View {
        if let headerDescription = headerDescription {
            HStack {
                RefdsText(headerDescription.uppercased(), style: .caption1, color: .secondary)
                Spacer()
            }
        } else if let header = header {
            HStack {
                AnyView(header())
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var macOSFooter: some View {
        if let footerDescription = footerDescription {
            HStack {
                RefdsText(footerDescription, style: .footnote, color: .secondary)
                Spacer()
            }
        } else if let footer = footer {
            HStack {
                AnyView(footer())
                Spacer()
            }
        }
    }
    
    private var iOSView: some View {
        Section {
            content()
        } header: {
            if let headerDescription = headerDescription {
                RefdsText(headerDescription.uppercased(), style: .caption1, color: .secondary)
            } else if let header = header { AnyView(header()) }
        } footer: {
            if let footerDescription = footerDescription {
                RefdsText(footerDescription, style: .footnote, color: .secondary)
            } else if let footer = footer { AnyView(footer()) }
        }
    }
}

extension Array where Element == GridItem {
    static func columns(width: CGFloat, maxAmount: Int? = nil) -> Self {
        var columnsAmount = Int(width / 350) < 1 ? 1 : Int(width / 350)
        if let maxAmount = maxAmount { columnsAmount = columnsAmount > maxAmount ? maxAmount : columnsAmount }
        return (0 ..< columnsAmount).map { _ in GridItem(.flexible()) }
    }
}

struct RefdsSection_Previews: PreviewProvider {
    static var previews: some View {
        RefdsList {
            RefdsSection(proxy: $0, headerDescription: "alert example", footerDescription: "Nullam non tempor purus, ut maximus sem. Sed vel erat et dolor scelerisque tincidunt eu quis ex.") {
                RefdsAlert(style: .basic(.warning, "Lorem Ipsum", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vestibulum dignissim tellus eu viverra. In in quam mauris.\n\nMauris arcu quam, maximus iaculis nibh a, vehicula aliquet leo. Nullam non tempor purus, ut maximus sem. Sed vel erat et dolor scelerisque tincidunt eu quis ex."))
                RefdsAlert(style: .inline(.critical, "Mauris arcu quam, maximus iaculis nibh a, vehicula aliquet leo."))
                RefdsAlert(style: .basic(.success, "Lorem Ipsum", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vestibulum dignissim tellus eu viverra. In in quam mauris.\n\nMauris arcu quam, maximus iaculis nibh a, vehicula aliquet leo."), primaryAction: .init(title: "Primary"), secondaryAction: .init(title: "Secondary"))
            }
        }
    }
}
