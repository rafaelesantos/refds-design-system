import Foundation

final class RefdsImageFeatureStorage {
    var imageCache: RefdsImageCacheProtocol = RefdsImageTemporaryCache()
    var network: RefdsImageNetworkProtocol = RefdsImageNetworkManager()
    
    static let shared = RefdsImageFeatureStorage()
    
    private init() {}
}
