import SwiftUI
import SafariServices

#if os(iOS)
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
#endif
extension URL: Identifiable {
    public var id: String { absoluteString }
}

extension Array: Identifiable where Element == URL {
    public var id: String { self.map { $0.absoluteString }.joined(separator: "-") }
}

extension String: Identifiable {
    public var id: String { self }
}
