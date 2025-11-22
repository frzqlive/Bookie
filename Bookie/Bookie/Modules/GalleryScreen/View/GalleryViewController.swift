import UIKit

final class GalleryViewController: UIViewController
{
    private let presenter: IGalleryPresenter
    private let galleryView = GalleryView()

    init(presenter: IGalleryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.galleryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppStrings.Gallery.title
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.presenter.didLoad(ui: galleryView)
    }
}
