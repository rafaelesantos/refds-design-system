import Foundation

public protocol RefdsImageCacheProtocol {
    subscript(_ url: URL) -> RefdsImageCrossPlatform? { get set }
    
    func setCacheLimit(countLimit: Int, totalCostLimit: Int)
    func removeCache()
}

struct RefdsImageTemporaryCache: RefdsImageCacheProtocol {
    private let cache: NSCache<NSURL, RefdsImageCrossPlatform> = {
        let cache = NSCache<NSURL, RefdsImageCrossPlatform>()
        return cache
    }()
    
    subscript(_ key: URL) -> RefdsImageCrossPlatform? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil ?
            cache.removeObject(forKey: key as NSURL) :
            cache.setObject(newValue ?? RefdsImageCrossPlatform(), forKey: key as NSURL)
        }
    }
    
    func setCacheLimit(countLimit: Int = 0, totalCostLimit: Int = 0) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    func removeCache() {
        cache.removeAllObjects()
    }
}
