import Foundation

@propertyWrapper
public struct RefdsImageCache {
    public var wrappedValue: RefdsImageCacheProtocol {
        get { storage.imageCache }
        nonmutating set { storage.imageCache = newValue }
    }
    
    private let storage: RefdsImageFeatureStorage
    
    public init() {
        storage = RefdsImageFeatureStorage.shared
    }
}
