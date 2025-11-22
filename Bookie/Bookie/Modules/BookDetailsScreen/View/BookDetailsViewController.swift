import UIKit

final class BookDetailsViewController: UIViewController
{
    private let detailsView = BookDetailsView()
    private let presenter: IBookDetailsPresenter

    init(presenter: IBookDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = AppStrings.BookDetails.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.presenter.didLoad(ui: self.detailsView)
    }
}
