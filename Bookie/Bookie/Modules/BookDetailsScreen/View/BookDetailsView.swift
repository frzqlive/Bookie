import UIKit
import SnapKit

protocol IBookDetailsView: AnyObject
{
    var didTapRead: (() -> Void)? { get set }
    var didTapFavorite: (() -> Void)? { get set }

    func update(_ state: BookDetailsViewState)
    func showFavoriteResult(_ result: SaveFavoriteResult)
}

final class BookDetailsView: UIView, IBookDetailsView
{
    var didTapRead: (() -> Void)? {
        get { self.actionsView.didTapRead }
        set { self.actionsView.didTapRead = newValue }
    }

    var didTapFavorite: (() -> Void)? {
        get { self.actionsView.didTapFavorite }
        set { self.actionsView.didTapFavorite = newValue }
    }

    private enum Constants {
        static let topOffset: CGFloat = 16
        static let doubleTopOffset: CGFloat = topOffset * 2
        static let horizontalInset: CGFloat = 24
        static let stackSpacing: CGFloat = 8
        static let errorLabelFontSize: CGFloat = 14
        static let errorLabelColor: UIColor = .systemRed
    }

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true
        return view
    }()

    private lazy var contentView = UIView()
    private lazy var coverImageView = BookCoverImageView()
    private lazy var infoView = BookInfoView()
    private lazy var metadataView = BookMetadataView()
    private lazy var actionsView = BookActionsView()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        return stack
    }()

    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        label.textColor = Constants.errorLabelColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookDetailsView
{
    func update(_ state: BookDetailsViewState) {
        switch state {
        case .loading(let viewModel):
            self.updateContent(with: viewModel, showPlaceholder: false)
            self.setLoading(true)
        case .content(let viewModel):
            self.updateContent(with: viewModel, showPlaceholder: true)
            self.setLoading(false)
        case .error(let message):
            self.setLoading(false)
            self.showDetailsError(message)
        }
    }

    func showFavoriteResult(_ result: SaveFavoriteResult) {
        switch result {
        case .success:
            self.hideErrorMessage()
            self.actionsView.configureFavoriteButton(
                isEnabled: false,
                title: AppStrings.BookDetails.addedToFavoritesButton,
                isHidden: false
            )
        case .alreadyExists:
            self.showDetailsError(AppStrings.BookDetails.alreadyInFavorites)
        case .error:
            self.showDetailsError(AppStrings.BookDetails.addingToFavoritesError)
        }
    }
}

private extension BookDetailsView
{
    func setupUI() {
        [self.scrollView, self.loader, self.errorLabel].forEach { self.addSubview($0) }
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.contentStack)

        [self.coverImageView, self.infoView, self.metadataView, self.actionsView].forEach {
            self.contentStack.addArrangedSubview($0)
        }

        self.setupConstraints()
    }

    func setupConstraints() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        self.loader.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        self.errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        self.contentStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.bottom.lessThanOrEqualToSuperview().offset(-Constants.topOffset)
        }

        self.coverImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }

        self.infoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        self.metadataView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        self.actionsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        self.contentStack.setCustomSpacing(Constants.topOffset, after: self.coverImageView)
        self.contentStack.setCustomSpacing(Constants.doubleTopOffset, after: self.metadataView)
    }
}

private extension BookDetailsView
{
    func updateContent(with viewModel: BookDetailsViewModel, showPlaceholder: Bool) {
        self.hideErrorMessage()

        self.coverImageView.configure(with: viewModel.coverImageURL)

        let isDescriptionHidden = showPlaceholder ? viewModel.isDescriptionHidden : (viewModel.description == AppStrings.BookDetails.noDescription)

        self.infoView.configure(
            title: viewModel.title,
            author: viewModel.authors,
            description: viewModel.description,
            isDescriptionHidden: isDescriptionHidden
        )

        self.metadataView.configure(
            metadata: viewModel.metadata,
            isMetadataHidden: viewModel.isMetadataHidden
        )

        self.actionsView.configure(
            readButtonTitle: viewModel.readButtonTitle,
            favoriteButtonTitle: viewModel.favoriteButtonTitle,
            isFavoriteEnabled: viewModel.isFavoriteButtonEnabled,
            isFavoriteHidden: !viewModel.isFavoriteButtonEnabled
        )

        self.contentStack.isHidden = false
        self.scrollView.isHidden = false
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            self.loader.startAnimating()
            self.loader.isHidden = false
        } else {
            self.loader.stopAnimating()
            self.loader.isHidden = true
        }
    }

    func showDetailsError(_ message: String) {
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
    }

    func hideErrorMessage() {
        self.errorLabel.isHidden = true
        self.errorLabel.text = nil
    }
}
