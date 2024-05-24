import SwiftUI

public struct RefdsShareRepresentable: UIViewControllerRepresentable {
    private var item: Any
    
    public init(item: Any) {
        self.item = item
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<RefdsShareRepresentable>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        controller.sheetPresentationController?.detents = [.medium(), .large()]
        return controller
    }
    
    public func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<RefdsShareRepresentable>
    ) {}
}
