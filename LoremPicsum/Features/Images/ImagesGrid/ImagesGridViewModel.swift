import Combine

class ImagesGridViewModel {
    var navigateToImageDetails: ((Image) -> Void)?
    @Published var state = State.loading
    private var images: [Image] = []
    private var currentPage = 1
    private var bag = Set<AnyCancellable>()
    private let repository: ImagesRepositoryType

    init(repository: ImagesRepositoryType) {
        self.repository = repository
    }

    func handleAction(_ action: Action) {
        switch action {
        case .initialLoad:
            loadImages()
        case let .loadMore(row):
            guard case let .loaded(images) = state,
                  row == images.count - 2 else { return }
            currentPage += 1
            loadMore()
        case let .navigateToImage(imageRow):
            guard images.indices.contains(imageRow) else { return }
            navigateToImageDetails?(images[imageRow])
        }
    }

    private func loadImages() {
        repository
            .loadImagesList(page: currentPage)
            .sink(receiveCompletion: { [weak self] result in
                if case let .failure(error) = result {
                    self?.state = .error(error)
                }
            }, receiveValue: { [unowned self] images in
                self.images = images
                self.state = .loaded(images)
            })
            .store(in: &bag)
    }

    private func loadMore() {
        repository
            .loadImagesList(page: currentPage)
            .replaceError(with: [])
            .sink(receiveValue: { [unowned self] images in
                self.images += images
                self.state = .loaded(self.images)
            })
            .store(in: &bag)
    }
}

// MARK: State

extension ImagesGridViewModel {
    enum State {
        case loading
        case loaded([Image])
        case error(APIError)
    }

    enum Action {
        case initialLoad
        case navigateToImage(Int)
        case loadMore(Int)
    }
}
