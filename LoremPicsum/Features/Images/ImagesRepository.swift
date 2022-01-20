import Combine

// sourcery:AutoMockable
protocol ImagesRepositoryType {
    func loadImagesList(page: Int) -> AnyPublisher<[Image], APIError>
}

class ImagesRepository: ImagesRepositoryType {
    private let apiClient: APIClientType

    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    func loadImagesList(page: Int) -> AnyPublisher<[Image], APIError> {
        apiClient
            .makeRequest(path: "v2/list", query: ["page": page.description])
            .eraseToAnyPublisher()
    }
}
