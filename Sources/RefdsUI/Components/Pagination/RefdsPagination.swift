import SwiftUI

public struct RefdsPagination: View {
    @State private var pages: [Int]
    @State private(set) var currentPage: Int
    private let color: RefdsColor
    private var canChangeToNextPage: () -> Bool
    private var selectedPage: (Int) -> Void
    
    public init(currentPage: Int = 1, color: RefdsColor = .accentColor, canChangeToNextPage: @escaping () -> Bool, selectedPage: @escaping (Int) -> Void) {
        self.selectedPage = selectedPage
        self.color = color
        var pages: [Int] = [1, 2, 3, 4]
        if pages.max() == currentPage {
            pages = pages.map({ $0 + 1 })
        } else if pages.min() == currentPage && (pages.min() ?? 0) > 1 {
            pages = pages.map({ $0 - 1 })
        } else if pages.max() ?? 0 < currentPage {
            pages = Array(((currentPage - 2) ... (currentPage + 1)))
        }
        self.pages = pages
        self.currentPage = currentPage
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
    }
    
    private var leftButton: some View {
        RefdsButton {
            if currentPage > 1 { actionButtonPage(onPage: currentPage - 1) }
        } label: {
            RefdsIcon(
                .chevronLeftCircleFill,
                color: color,
                size: 20,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
        .disabled(currentPage == 1)
    }
    
    private var rightButton: some View {
        RefdsButton {
            actionButtonPage(onPage: currentPage + 1)
        } label: {
            RefdsIcon(
                .chevronRightCircleFill,
                color: color,
                size: 20,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
        .disabled(!canChangeToNextPage())
    }
    
    private var pageNumbers: some View {
        HStack {
            ForEach(pages, id: \.self) { makeButtonPage(with: $0) }
        }
    }
    
    private func makeButtonPage(with page: Int) -> some View {
        RefdsButton { actionButtonPage(onPage: page) } label: {
            RefdsText(
                "\(page)",
                style: .body,
                color: currentPage == page ? color : (page > currentPage && !canChangeToNextPage()) ? .secondary : .primary
            )
            .frame(width: 30, height: 50)
        }
        .disabled((page > currentPage && !canChangeToNextPage()))
    }
    
    private func actionButtonPage(onPage page: Int) {
        if canChangeToNextPage() || (!canChangeToNextPage() && page < currentPage) {
            selectedPage(page)
            pages = updatedPages(pages, page: page)
            currentPage = page
        }
    }
    
    private func updatedPages(_ pages: [Int], page: Int) -> [Int] {
        var pages = pages
        if pages.max() == page {
            pages = pages.map({ $0 + 1 })
        } else if pages.min() == page && (pages.min() ?? 0) > 1 {
            pages = pages.map({ $0 - 1 })
        }
        return pages
    }
}

struct RefdsPagination_Previews: PreviewProvider {
    static var previews: some View {
        RefdsPagination(currentPage: 7, canChangeToNextPage: { false }, selectedPage: { _ in })
    }
}
