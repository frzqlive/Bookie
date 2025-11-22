import UIKit

protocol IMyBooksRouter
{
    func openBookDetails(book: Book)
}

final class MyBooksRouter: IMyBooksRouter
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

    func openBookDetails(book: Book) {
        guard let navigationController = self.navigationController else { return }
        let bookDetailsVC = BookDetailsAssembly.makeModule(
            book: book,
            isFavoriteButtonNeeded: false,
            dependencies: self.detailsDependencies
        )
        navigationController.pushViewController(bookDetailsVC, animated: true)
    }
}

