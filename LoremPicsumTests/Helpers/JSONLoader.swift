import Combine
import Foundation
@testable import LoremPicsum

class JSONLoader {
    static func loadJSON<T: Decodable>(named: String) -> AnyPublisher<T, APIError> {
        let bundle = Bundle(for: self)
        let url = bundle.url(forResource: named, withExtension: "json")
        let jsonData = try! Data(contentsOf: url!)
        let data = try! JSONDecoder().decode(T.self, from: jsonData)
        return Just(data).mapError { _ in APIError.badURL }.eraseToAnyPublisher()
    }
}
