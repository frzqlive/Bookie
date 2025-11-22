import UIKit

protocol IGalleryRouter
{
    func openBookDetails(book: Book)
}

final class GalleryRouter
{
    private weak var navigationController: UINavigationController?
    private let detailsDependencies: BookDetailsAssembly.Dependencies

    init(
        navigationController: UINavigationController,
        detailsDependencies: BookDetailsAssembly.Dependencies
    ) {
        self.navigationController = navigationController
        self.detailsDependencies = detailsDependencies
    }
}

extension GalleryRouter: IGalleryRouter
{
    func openBookDetails(book: Book) {
        guard let nav = self.navigationController else { return }
        let bookDetailsVC = BookDetailsAssembly.makeModule(
            book: book,
            isFavoriteButtonNeeded: true,
            dependencies: self.detailsDependencies
        )
        nav.pushViewController(bookDetailsVC, animated: true)
    }
}
