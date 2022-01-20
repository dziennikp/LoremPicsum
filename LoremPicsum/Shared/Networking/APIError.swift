import Foundation

enum APIError: Error {
    case badURL
    case decodingFailed(Error)
    case networkError(URLError.Code, String)

    var errorLabel: String {
        switch self {
        case .badURL: return "Bad URL"
        case let .decodingFailed(error): return error.localizedDescription
        case let .networkError(code, error): return "\(code.rawValue) - \(error)"
        }
    }
}
