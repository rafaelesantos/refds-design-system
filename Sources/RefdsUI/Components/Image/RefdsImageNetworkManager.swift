import Foundation
import Combine

enum RefdsImageNetworkError: LocalizedError {
    case badURL(String = "Bad URL or nil.")
    case transportError(Error)
    case badResponse(String)
    
    var rawValue: String {
        switch self {
        case .badURL(let message):
            return message
        case .transportError(let error):
            return error.localizedDescription
        case .badResponse(let message):
            return message
        }
    }
}

protocol RefdsImageNetworkProtocol {
    func fetchImage(from url: URL?) -> (
        progress: Progress?,
        publisher: AnyPublisher<Data, Error>
    )
}

struct RefdsImageNetworkManager: RefdsImageNetworkProtocol {
    func fetchImage(from url: URL?) -> (
        progress: Progress?,
        publisher: AnyPublisher<Data, Error>
    ) {
        guard let url = url else {
            return (
                nil,
                Fail(error: RefdsImageNetworkError.badURL()).eraseToAnyPublisher()
            )
        }
        
        let sharedPublisher = URLSession.shared
            .dataTaskProgressPublisher(for: url)
        
        let progress = sharedPublisher
            .progress
        
        let result = sharedPublisher
            .publisher
            .mapError { RefdsImageNetworkError.transportError($0) }
            .tryMap { element in
                if let httpResponse = element.response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    throw RefdsImageNetworkError.badResponse(
                        "Bad response. Status code: \(httpResponse.statusCode)"
                    )
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
        
        return (progress, result)
    }
}

extension URLSession {
    typealias DataTaskProgressPublisher = (
        progress: Progress?,
        publisher: AnyPublisher<DataTaskPublisher.Output, Error>
    )
    
    func dataTaskProgressPublisher(for url: URL) -> DataTaskProgressPublisher {
        let progress = Progress(totalUnitCount: 1)
        
        let result = Deferred {
            Future<DataTaskPublisher.Output, Error> { handler in
                let task = self.dataTask(
                    with: URLRequest(url: url)
                ) { data, response, error in
                    if let error = error {
                        handler(.failure(error))
                    } else if let data = data, let response = response {
                        handler(.success((data, response)))
                    }
                }
                
                progress.addChild(task.progress, withPendingUnitCount: 1)
                task.resume()
            }
        }
        .share()
        .eraseToAnyPublisher()
        
        return (progress, result)
    }
}
