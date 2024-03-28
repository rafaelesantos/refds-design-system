import SwiftUI

public struct RefdsPagination: View {
    @State private var pages: [Int] = []
    @Binding private var currentPage: Int
    private let color: RefdsColor
    private var canChangeToNextPage: () -> Bool
    
    public init(
        currentPage: Binding<Int>,
        color: RefdsColor = .accentColor,
        canChangeToNextPage: @escaping () -> Bool
    ) {
        self.color = color
        self._currentPage = currentPage
        self.canChangeToNextPage = canChangeToNextPage
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                leftButton
                Spacer(minLength: 6)
                pageNumbers
                Spacer(minLength: 6)
                rightButton
            }
        }
        .padding(.horizontal, 30)
        .onAppear { updatedPages([1, 2, 3, 4, 5], page: currentPage) }
    }
    
    private var isDisableLeftButton: Bool {
        currentPage == 1
    }
    
    private var isDisableRightButton: Bool {
        !canChangeToNextPage()
    }
    
    private var leftButton: some View {
        RefdsButton {
            if currentPage > 1 { actionButtonPage(onPage: currentPage - 1) }
        } label: {
            RefdsIcon(
                .chevronLeft,
                color: isDisableLeftButton ? .placeholder : color,
                style: .footnote,
                weight: .bold,
                renderingMode: .hierarchical
            )
            .frame(
                width: .padding(.large),
                height: .padding(.large)
            )
            .background((isDisableLeftButton ? .placeholder : color).opacity(0.2))
            .clipShape(.circle)
        }
        .disabled(isDisableLeftButton)
    }
    
    private var rightButton: some View {
        RefdsButton {
            actionButtonPage(onPage: currentPage + 1)
        } label: {
            RefdsIcon(
                .chevronRight,
                color: isDisableRightButton ? .placeholder : color,
                style: .footnote,
                weight: .bold,
                renderingMode: .hierarchical
            )
            .frame(
                width: .padding(.large),
                height: .padding(.large)
            )
            .background((isDisableRightButton ? .placeholder : color).opacity(0.2))
            .clipShape(.circle)
        }
        .disabled(isDisableRightButton)
    }
    
    private var pageNumbers: some View {
        HStack(spacing: .padding(.large)) {
            ForEach(pages, id: \.self) {
                makeButtonPage(with: $0)
            }
        }
    }
    
    private func makeButtonPage(with page: Int) -> some View {
        RefdsButton { actionButtonPage(onPage: page) } label: {
            RefdsText(
                page.asString,
                style: .footnote,
                color: currentPage == page ? color : (page > currentPage && !canChangeToNextPage()) ? .placeholder : .primary,
                weight: currentPage == page ? .bold : .regular
            )
        }
        .disabled((page > currentPage && !canChangeToNextPage()))
        .animation(.default, value: currentPage)
    }
    
    private func actionButtonPage(onPage page: Int) {
        if canChangeToNextPage() || (!canChangeToNextPage() && page < currentPage) {
            updatedPages(pages, page: page)
            currentPage = page
        }
    }
    
    private func updatedPages(_ pages: [Int], page: Int) {
        var pages = pages
        if pages.max() == currentPage {
            pages = pages.map({ $0 + 1 })
        } else if pages.min() == currentPage && (pages.min() ?? 0) > 1 {
            pages = pages.map({ $0 - 1 })
        } else if pages.max() ?? 0 < currentPage {
            pages = Array(((currentPage - 2) ... (currentPage + 1)))
        }
        self.pages = pages
    }
}

#Preview {
    struct ContainerView: View {
        @State private var page: Int = 7
        var body: some View {
            VStack(alignment: .leading, spacing: .padding(.medium)) {
                RefdsPagination(
                    currentPage: $page,
                    canChangeToNextPage: { page < 14 }
                )
            }
            .padding(.padding(.large))
        }
    }
    return ContainerView()
}
