import SwiftUI
import SafariServices

public struct RefdsSafari: UIViewControllerRepresentable {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<RefdsSafari>
    ) {}
}

extension URL: Identifiable {
    public var id: String { absoluteString }
}
