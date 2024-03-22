import Foundation

@propertyWrapper
struct RefdsImageNetwork {
    var wrappedValue: RefdsImageNetworkProtocol {
        get { storage.network }
        nonmutating set { storage.network = newValue }
    }
    
    private let storage: RefdsImageFeatureStorage
    
    init() {
        storage = RefdsImageFeatureStorage.shared
    }
}
