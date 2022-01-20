import UIKit

class RootViewController: UINavigationController {
    private let apiClient: APIClient
    private let imagesRepository: ImagesRepository
    private let imagesViewModel: ImagesGridViewModel

    init() {
        apiClient = APIClient()
        imagesRepository = ImagesRepository(apiClient: apiClient)
        imagesViewModel = ImagesGridViewModel(repository: imagesRepository)
        super.init(rootViewController: ImagesGridViewController(viewModel: imagesViewModel))
        imagesViewModel.navigateToImageDetails = { [weak self] image in
            self?.showDetails(for: image)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showDetails(for image: Image) {
    }
}
