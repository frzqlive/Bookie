import UIKit
import SnapKit

protocol IGalleryView: AnyObject
{
    var didSelectBook: ((Int) -> Void)? { get set }
    var didChangeSearchText: ((String) -> Void)? { get set }
    func showBooks(with books: [BookViewModel])
    func showLoading()
    func showError(_ error: Error)
    func showEmptyState(_ show: Bool)
}

final class GalleryView: UIView
{
    private enum Constants
    {
        static let searchBarTopInset: CGFloat = 16
        static let searchBarHorizontalInset: CGFloat = 16
        static let collectionViewTopOffset: CGFloat = 12
        static let emptyStateLabelPadding: CGFloat = 24
        static let itemsInRow: CGFloat = 3
        static let minimumLineSpacing: CGFloat = 16
        static let minimumInteritemSpacing: CGFloat = 16
        static let sectionInset: UIEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 20)
        static let labelHeight: CGFloat = 20
        static let labelPadding: CGFloat = 16
    }

    private lazy var searchBarView: SearchBarView = {
        let searchBar = SearchBarView()
        searchBar.delegate = self
        return searchBar
    }()

    private let collectionManager = GalleryCollectionManager()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.sectionInset = Constants.sectionInset
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        view.backgroundColor = .systemBackground
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .always
        view.dataSource = self.collectionManager
        view.delegate = self.collectionManager
        view.register(
            GalleryCollectionCell.self,
            forCellWithReuseIdentifier: GalleryCollectionCell.reuseIdentifier
        )
        return view
    }()

    private let loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = AppStrings.Gallery.emptyState
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        label.isHidden = true
        return label
    }()

    var didSelectBook: ((Int) -> Void)?
    var didChangeSearchText: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GalleryView
{
    func setupView() {
        self.backgroundColor = .systemBackground

        self.addSubview(self.searchBarView)
        self.addSubview(self.collectionView)
        self.addSubview(self.loader)
        self.addSubview(self.emptyStateLabel)

        self.collectionManager.didSelectBookAt = { [weak self] index in
            self?.didSelectBook?(index)
        }

        self.searchBarView.delegate = self

        self.setupConstraints()
    }

    func setupConstraints() {
        self.searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Constants.searchBarTopInset)
            make.leading.trailing.equalToSuperview().inset(Constants.searchBarHorizontalInset)
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom).offset(Constants.collectionViewTopOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }

        self.loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.emptyStateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.emptyStateLabelPadding)
        }
    }
}

extension GalleryView: IGalleryView
{
    func showBooks(with books: [BookViewModel]) {
        self.collectionManager.update(books: books)
        self.collectionView.reloadData()
        self.loader.stopAnimating()
        self.showEmptyState(books.isEmpty)
    }

    func showLoading() {
        self.loader.startAnimating()
    }

    func showError(_ error: Error) {
        self.loader.stopAnimating()
        self.emptyStateLabel.text = error.localizedDescription
        self.showEmptyState(true)
    }

    func showEmptyState(_ show: Bool) {
        self.emptyStateLabel.isHidden = !show
        self.collectionView.isHidden = show
        if show {
            self.loader.stopAnimating()
            if self.emptyStateLabel.text?.isEmpty ?? true {
                self.emptyStateLabel.text = AppStrings.Gallery.emptyState
            }
        }
    }
}

extension GalleryView: ISearchBarView
{
    func searchBar(_ searchBar: SearchBarView, didChangeSearchText searchText: String) {
        self.didChangeSearchText?(searchText)
    }
}

extension GalleryView
{
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let items = Constants.itemsInRow
        let spacing = layout.minimumInteritemSpacing
        let insets = layout.sectionInset.left + layout.sectionInset.right

        let totalSpacing = insets + (items - 1) * spacing
        let width = (self.bounds.width - totalSpacing) / items

        let height = width + Constants.labelHeight + Constants.labelPadding

        let newSize = CGSize(width: width, height: height)
        if layout.itemSize != newSize {
            layout.itemSize = newSize
        }
    }
}
