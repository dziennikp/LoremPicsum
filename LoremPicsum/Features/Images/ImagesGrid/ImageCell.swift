import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: Image) {
        guard imageView.sd_imageURL == nil else { return }
        let url = URL(string: image.download_url)
        let scale = UIScreen.main.scale
        let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale)
        imageView.sd_setImage(with: url, placeholderImage: nil, context: [.imageThumbnailPixelSize : thumbnailSize])
    }

    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
}
