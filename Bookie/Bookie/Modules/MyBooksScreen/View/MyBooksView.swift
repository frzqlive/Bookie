import UIKit
import SnapKit

protocol IMyBooksView: AnyObject
{
    var didSelectBook: ((IndexPath) -> Void)? { get set }
    var didDeleteBook: ((IndexPath) -> Void)? { get set }
    var didChangeStatus: ((IndexPath, ReadingStatus) -> Void)? { get set }
    func showBooks(_ sections: [MyBooksSectionViewModel])
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
    func showEmptyState(_ show: Bool)
}

final class MyBooksView: UIView, IMyBooksView
{
    private enum Constants
    {
        static let tableViewInsets: UIEdgeInsets = .zero
        static let emptyStateLabelPadding: CGFloat = 24
        static let emptyStateText = AppStrings.MyBooks.emptyState
    }

    var didSelectBook: ((IndexPath) -> Void)?
    var didDeleteBook: ((IndexPath) -> Void)?
    var didChangeStatus: ((IndexPath, ReadingStatus) -> Void)?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.isHidden = true
        return tableView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyStateText
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        label.isHidden = true
        return label
    }()

    private let dataSource = MyBooksTableViewDataSource()
    private let tableDelegate = MyBooksTableViewDelegate()
    private let statusMenuOptions: [(ReadingStatus, String)] = [
        (.reading, AppStrings.MyBooks.readingTitle),
        (.wantToRead, AppStrings.MyBooks.wantToReadTitle),
        (.finished, AppStrings.MyBooks.finishedTitle)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .systemBackground

        self.addSubview(self.tableView)
        self.addSubview(self.loadingIndicator)
        self.addSubview(self.emptyStateLabel)

        self.tableView.register(
            MyBooksTableViewCell.self,
            forCellReuseIdentifier: MyBooksTableViewCell.reuseIdentifier
        )
        self.tableView.dataSource = self.dataSource

        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.tableViewInsets)
        }

        self.loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.emptyStateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.emptyStateLabelPadding)
        }

        self.tableView.delegate = self.tableDelegate

        self.tableDelegate.didSelectBookAt = { [weak self] indexPath in
            self?.didSelectBook?(indexPath)
        }

        self.tableDelegate.didDeleteBookAt = { [weak self] indexPath in
            self?.didDeleteBook?(indexPath)
        }

        self.tableDelegate.statusMenuOptions = self.statusMenuOptions
        self.tableDelegate.statusProvider = { [weak self] indexPath in
            self?.dataSource.status(for: indexPath.section)
        }
        self.tableDelegate.didChangeStatusAt = { [weak self] indexPath, status in
            self?.didChangeStatus?(indexPath, status)
        }
    }

    func showBooks(_ sections: [MyBooksSectionViewModel]) {
        self.dataSource.update(sections: sections)
        self.tableView.reloadData()
        self.showEmptyState(sections.allSatisfy { $0.books.isEmpty })
    }

    func showLoading() {
        self.loadingIndicator.startAnimating()
        self.tableView.isHidden = true
        self.emptyStateLabel.isHidden = true
    }

    func hideLoading() {
        self.loadingIndicator.stopAnimating()
    }

    func showError(_ error: Error) {
        self.emptyStateLabel.text = error.localizedDescription
        self.showEmptyState(true)
    }

    func showEmptyState(_ show: Bool) {
        self.emptyStateLabel.isHidden = !show
        self.tableView.isHidden = show
        if show, self.emptyStateLabel.text?.isEmpty ?? true {
            self.emptyStateLabel.text = Constants.emptyStateText
        }
    }
}
