import SwiftUI

public struct RefdsCollapse: View {
    @State private var isCollapsed: Bool
    
    private var title: String?
    private var content: () -> any View
    private var header: (() -> any View)?
    private let action: ((Bool) -> Void)?
    
    public init(
        isCollapsed: Bool = true,
        title: String,
        content: @escaping () -> any View,
        action: ((Bool) -> Void)? = nil
    ) {
        self._isCollapsed = State(initialValue: isCollapsed)
        self.title = title
        self.content = content
        self.action = action
    }
    
    public init(
        isCollapsed: Bool = true,
        header: (() -> any View)? = nil,
        content: @escaping () -> any View,
        action: ((Bool) -> Void)? = nil
    ) {
        self._isCollapsed = State(initialValue: isCollapsed)
        self.content = content
        self.header = header
        self.action = action
    }
    
    public var body: some View {
        RefdsButton {
            withAnimation { 
                isCollapsed.toggle()
                action?(isCollapsed)
            }
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
