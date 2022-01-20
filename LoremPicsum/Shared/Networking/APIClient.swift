import Combine
import Foundation

protocol APIClientType {
    func makeRequest<T: Decodable>(path: String, query: [String: String]) -> AnyPublisher<T, APIError>
}

class APIClient: APIClientType {
    private let baseURL = "https://picsum.photos/"
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func makeRequest<T: Decodable>(path: String, query: [String: String]) -> AnyPublisher<T, APIError> {
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
        guard let url = urlComponents?.url else { return Fail(error: APIError.badURL).eraseToAnyPublisher() }
        return urlSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { APIError.networkError($0.code, $0.localizedDescription) }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError(APIError.decodingFailed)
            .eraseToAnyPublisher()
    }
}
