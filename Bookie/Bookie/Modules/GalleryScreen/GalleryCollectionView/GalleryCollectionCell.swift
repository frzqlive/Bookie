import UIKit
import SnapKit
import Kingfisher

final class GalleryCollectionCell: UICollectionViewCell
{
    static let reuseIdentifier = "GalleryCollectionCell"

    private enum Constants
    {
        static let cornerRadius: CGFloat = 10
        static let titleFontSize: CGFloat = 14
        static let titleFontWeight: UIFont.Weight = .semibold
        static let maxTitleLines: Int = 2
        static let padding: CGFloat = 8
        static let placeholderIconName = "book.closed"
        static let fadeTransitionDuration = 0.2
        static let loaderBackgroundAlpha: CGFloat = 0.7
    }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private let loadingOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(Constants.loaderBackgroundAlpha)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: Constants.titleFontWeight)
        label.textAlignment = .center
        label.numberOfLines = Constants.maxTitleLines
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.kf.cancelDownloadTask()
        self.imageView.image = nil
        self.titleLabel.text = nil
        self.hideLoadingState()
    }
}

extension GalleryCollectionCell
{
    func configure(with model: BookViewModel) {
        self.titleLabel.text = model.title
        self.imageView.image = nil

        if let imageURL = model.coverURL {
            self.showLoadingState()
            self.imageView.kf.setImage(
                with: imageURL,
                placeholder: nil,
                options: [.transition(.fade(Constants.fadeTransitionDuration))]
            ) { [weak self] result in
                guard let self = self else { return }
                self.hideLoadingState()

                if case .failure = result {
                    self.imageView.image = UIImage(systemName: Constants.placeholderIconName)
                }
            }
        } else {
            self.hideLoadingState()
            self.imageView.image = UIImage(systemName: Constants.placeholderIconName)
        }
    }
}

private extension GalleryCollectionCell
{
    func setupUI() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.imageView.addSubview(self.loadingOverlay)
        self.loadingOverlay.addSubview(self.activityIndicator)

        self.imageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(self.imageView.snp.width)
        }

        self.loadingOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(Constants.padding)
            $0.left.right.bottom.equalToSuperview().inset(Constants.padding)
        }
    }

    func showLoadingState() {
        self.loadingOverlay.isHidden = false
        self.activityIndicator.startAnimating()
    }

    func hideLoadingState() {
        self.loadingOverlay.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}
