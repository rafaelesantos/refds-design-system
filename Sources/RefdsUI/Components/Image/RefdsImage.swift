import SwiftUI

public struct RefdsAsyncImage: View {
    @StateObject private var imageLoader: RefdsImageLoader
    
    private let url: String
    private let placeholder: ((String) -> any View)?
    private let image: (RefdsImageCrossPlatform) -> any View
    private let error: ((String, @escaping () -> Void) -> any View)?
    
    public init(
        url: String,
        placeholder: ((String) -> any View)? = nil,
        image: @escaping (RefdsImageCrossPlatform) -> any View,
        error: ((String, @escaping () -> Void) -> any View)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: RefdsImageLoader(
                imageCache: RefdsImageCache().wrappedValue,
                networkManager: RefdsImageNetwork().wrappedValue
            )
        )
        
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.error = error
    }
    
    public var body: some View {
        ZStack {
            switch imageLoader.state {
            case .idle:
                Color.clear
                    .onAppear {
                        fetchImage(from: url)
                    }
            case .loading(let progress):
                if let placeholder = placeholder {
                    let percentValue = Int(progress * 100)
                    let progress = String(percentValue)
                    
                    AnyView(placeholder(progress))
                }
            case .failed(let errorMessage):
                if let error = error {
                    AnyView(error(errorMessage, { fetchImage(from: url) }))
                }
            case .loaded(let image):
                AnyView(self.image(image))
            }
        }
        .onChange(of: url, { fetchImage(from: url) })
    }
    
    private func fetchImage(from url: String) {
        imageLoader.fetchImage(from: url)
    }
}
