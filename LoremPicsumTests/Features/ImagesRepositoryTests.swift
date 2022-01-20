import XCTest
@testable import LoremPicsum
import Combine

class ImagesRepositoryTests: XCTestCase {
    private var repository: ImagesRepository!
    private var bag = Set<AnyCancellable>()

    override func setUpWithError() throws {
        repository = ImagesRepository(apiClient: FakeAPIClient())
    }

    func testLoadImagesList() {
        var images: [Image] = []
        var error: Error?
        let expectation = self.expectation(description: "Images")

        repository
            .loadImagesList(page: 0)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                    }

                    expectation.fulfill()
                        }, receiveValue: { value in
                            images = value
                        })
                        .store(in: &bag)
        wait(for: [expectation], timeout: 10)
        XCTAssertNil(error)
        XCTAssert(images.count == 30, "There should be 30 images")
    }
}

extension ImagesRepositoryTests {
    class FakeAPIClient: APIClientType {
        func makeRequest<T>(path: String, query: [String : String]) -> AnyPublisher<T, APIError> where T : Decodable {
            JSONLoader.loadJSON(named: "imagesList")
        }
    }
}
