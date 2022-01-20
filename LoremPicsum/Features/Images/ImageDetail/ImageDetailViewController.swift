import UIKit

class ImageDetailsViewController: UIViewController {
    private let imageView = UIImageView()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let viewModel: Image

    init(viewModel: Image) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(authorLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            authorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            authorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            authorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 32),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ]
        constraints.forEach { $0.isActive = true }

        authorLabel.text = "Author: " + viewModel.author
        imageView.sd_setImage(with: URL(string: viewModel.download_url))
        imageView.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share))
    }

    @objc private func share() {
        guard let image = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image],
                                                              applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension ImageDetailsViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        viewModel
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        viewModel
    }

    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        imageView.image
    }
}
