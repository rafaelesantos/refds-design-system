//
//  RefdsShare.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import SwiftUI

#if os(iOS)
struct RefdsShare: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
#endif

public struct RefdsShareItem: Identifiable {
    public let id: UUID = .init()
    public let items: [Any]
    
    public init(items: [Any]) {
        self.items = items
    }
}

public extension View {
    func refdsShare(item: Binding<RefdsShareItem?>) -> some View {
        self.sheet(item: item) { _ in
            if let items = item.wrappedValue?.items {
                #if os(iOS)
                RefdsShare(activityItems: items)
                #endif
            }
        }
    }
}

struct RefdsShareView: View {
    @State private var shareItem: RefdsShareItem?
    
    var body: some View {
        RefdsButton("Share item") {
            shareItem = .init(items: [URL(string: "google.com")!])
        }
        .refdsShare(item: $shareItem)
    }
}

struct RefdsShare_Previews: PreviewProvider {
    static var previews: some View {
        RefdsShareView()
            .padding()
    }
}
