import Foundation
import RefdsShared
import Combine

final class RefdsImageLoader: ObservableObject {
    enum State {
        case idle
        case loading(_ progress: Double = .zero)
        case failed(_ error: String)
        case loaded(_ image: RefdsImageCrossPlatform)
    }
    
    @Published private(set) var state: State = .idle
    
    private var imageCache: RefdsImageCacheProtocol
    private let networkManager: RefdsImageNetworkProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    private static let imageProcessing = DispatchQueue(
        label: "com.cachedAsyncImage.imageProcessing"
    )
    
    init(
        imageCache: RefdsImageCacheProtocol,
        networkManager: RefdsImageNetworkProtocol
    ) {
        self.imageCache = imageCache
        self.networkManager = networkManager
    }
    
    deinit { cancel() }
    
    func fetchImage(from url: String) {
        if case .loading = state { return }
        
        if let url = URL(string: url),
           let cachedImage = imageCache[url] {
            state = .loaded(cachedImage)
            return
        }
        
        let (progress, data) = networkManager.fetchImage(from: URL(string: url))
        
        progress?
            .publisher(for: \.fractionCompleted)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fractionCompleted in
                self?.state = .loading(fractionCompleted)
            }
            .store(in: &cancellables)
        
        data
            .map { RefdsImageCrossPlatform(data: $0) }
            .catch { [weak self] error -> AnyPublisher<RefdsImageCrossPlatform?, Never> in
                if let error = error as? RefdsImageNetworkError {
                    Task { @MainActor [weak self] in
                        self?.state = .failed(error.rawValue)
                    }
                    
                    self?.log(error.rawValue, url: url)
                }
                
                return Just(nil).eraseToAnyPublisher()
            }
            .handleEvents(
                receiveSubscription: { _ in
                    Task { @MainActor [weak self] in
                        self?.state = .loading()
                    }
                },
                receiveOutput: { [weak self] in
                    self?.cache(url: URL(string: url), image: $0)
                }
            )
            .subscribe(on: Self.imageProcessing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.state = .loaded(image)
            }
            .store(in: &cancellables)
    }
    
    private func cache(url: URL?, image: RefdsImageCrossPlatform?) {
        guard let url = url else { return }
        image.map { imageCache[url] = $0 }
    }
    
    private func cancel() {
        cancellables.forEach { $0.cancel() }
    }
    
    private func log(_ error: String, url: String) {
        let errorMessage = "REFDSIMAGE \(url) \(error)"
        RefdsLoggerTag.error(message: errorMessage).console()
    }
}
