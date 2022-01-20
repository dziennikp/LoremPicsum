import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(for: URL) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}
