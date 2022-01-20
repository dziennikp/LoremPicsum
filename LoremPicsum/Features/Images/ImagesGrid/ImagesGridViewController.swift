import Combine
import UIKit

class ImagesGridViewController: UIViewController {
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    private var viewModel: ImagesGridViewModel
    private var bag = Set<AnyCancellable>()
    private var loadingIndicator = UIActivityIndicatorView()
    private var errorLabel = UILabel()

    init(viewModel: ImagesGridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindToViewModel()
        title = "Image grid"
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupView()
        viewModel.handleAction(.initialLoad)
    }

    override func loadView() {
        super.loadView()
        view = collectionView
        collectionView.delegate = self
    }

    private func setupView() {
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            loadingIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
        ]
        constraints.forEach { $0.isActive = true }
    }

    private func bindToViewModel() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case let .error(error):
                    self?.setupErrorState(error)
                case let .loaded(images):
                    self?.errorLabel.isHidden = true
                    self?.loadingIndicator.stopAnimating()
                    self?.applyData(images)
                case .loading:
                    self?.setupLoadingState()
                }
            })
            .store(in: &bag)
    }

    private func setupErrorState(_ error: APIError) {
        errorLabel.isHidden = false
        loadingIndicator.isHidden = true
        errorLabel.text = "\(error.errorLabel)"
        errorLabel.textAlignment = .center
    }

    private func setupLoadingState() {
        errorLabel.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    private func applyData(_ data: [Image]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Image>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        dataSource.apply(snapshot)
    }

    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let columnsCount = self.numberOfColumns(for: environment.container.contentSize.width)
            let heightFactor = 1 / CGFloat(columnsCount)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(heightFactor))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                           subitem: item,
                                                           count: columnsCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 16, bottom: self.view.safeAreaInsets.bottom, trailing: 16)
            return section
        }
    }

    private func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Image> {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
            cell.configure(with: item)

            self?.viewModel.handleAction(.loadMore(indexPath.row))
            return cell
        }
    }

    private func numberOfColumns(for width: CGFloat) -> Int {
        if width <= 414 {
            return 2
        } else if width < 1024 {
            return 4
        } else {
            return 8
        }
    }
}

extension ImagesGridViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.handleAction(.navigateToImage(indexPath.row))
    }
}
