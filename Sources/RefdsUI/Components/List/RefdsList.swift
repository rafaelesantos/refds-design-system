import SwiftUI

public struct RefdsList<Content: View>: View {
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        #if os(macOS)
        ScrollView {
            content()
        }
        .scrollContentBackground(.hidden)
        #else
        List {
            content()
        }
        #endif
    }
}

#Preview {
    RefdsList {
        RefdsText(.someWord())
    }
}
