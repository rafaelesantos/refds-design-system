import SwiftUI

#if os(iOS)
public struct RefdsShareRepresentable: UIViewControllerRepresentable {
    private var items: [Any]
    
    public init(items: [Any]) {
        self.items = items
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<RefdsShareRepresentable>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    public func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<RefdsShareRepresentable>
    ) {}
}
#endif
