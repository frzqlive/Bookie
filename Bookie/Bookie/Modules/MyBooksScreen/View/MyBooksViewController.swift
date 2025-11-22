import UIKit

final class MyBooksViewController: UIViewController
{
    private let presenter: IMyBooksPresenter
    private let myBooksView = MyBooksView()

    init(presenter: IMyBooksPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.myBooksView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppStrings.MyBooks.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.presenter.didLoad(ui: self.myBooksView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.refresh()
    }
}
