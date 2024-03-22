import SwiftUI

public struct RefdsCollapse: View {
    @State private var isCollapsed: Bool
    
    private var title: String?
    private var content: () -> any View
    private var header: (() -> any View)?
    
    public init(
        isCollapsed: Bool = true,
        title: String,
        content: @escaping () -> any View
    ) {
        self._isCollapsed = State(initialValue: isCollapsed)
        self.title = title
        self.content = content
    }
    
    public init(
        isCollapsed: Bool = true,
        header: (() -> any View)? = nil,
        content: @escaping () -> any View
    ) {
        self._isCollapsed = State(initialValue: isCollapsed)
        self.content = content
        self.header = header
    }
    
    public var body: some View {
        RefdsButton {
            withAnimation { isCollapsed.toggle() }
        } label: { toggle }
        
        if isCollapsed { AnyView(content()) }
    }
    
    private var toggle: some View {
        HStack {
            if let title = title {
                RefdsText(title)
                Spacer()
            } else if let header = header {
                AnyView(header())
                Spacer()
            }
            
            RefdsIcon(.chevronUp, color: .placeholder, size: 15)
                .rotationEffect(.degrees(isCollapsed ? 0 : 180))
        }
    }
}

#Preview {
    struct ContainerView: View {
        @State var isCollapsed: Bool = true
        var body: some View {
            List {
                RefdsCollapse(title: .someWord()) {
                    ForEach(1...3, id: \.self) { _ in
                        HStack(spacing: .padding(.large)) {
                            RefdsIcon(.random, color: .random, size: 30)
                            RefdsText(.someParagraph())
                        }
                    }
                }
            }
        }
    }
    return ContainerView()
}
