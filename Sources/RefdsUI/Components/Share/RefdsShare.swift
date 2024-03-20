//
//  RefdsShare.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import SwiftUI

public struct RefdsShare<Content: View>: View {
    public typealias Callback = (_ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    private let activityItems: [Any]
    private let callback: Callback?
    @ViewBuilder private let content: () -> Content
    
    public init(
        activityItems: [Any],
        callback: Callback? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.activityItems = activityItems
        self.callback = callback
        self.content = content
    }
    
    public var body: some View {
        RefdsButton { present() } label: { content() }
    }
    
    func present() {
#if os(iOS)
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.completionWithItemsHandler = { _, complete, returnedItems, error in
            self.callback?(complete, returnedItems, error)
        }
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        if let windowScene = scene as? UIWindowScene {
            windowScene.keyWindow?.rootViewController?.present(
                controller,
                animated: true,
                completion: nil
            )
        }
#endif
    }
}

struct RefdsShare_Previews: PreviewProvider {
    static var previews: some View {
        RefdsShare(activityItems: [URL(string: "google.com")!]) {
            RefdsText("Share Googlex")
        }
    }
}
