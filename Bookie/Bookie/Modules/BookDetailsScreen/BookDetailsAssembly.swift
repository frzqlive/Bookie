import UIKit

enum BookDetailsAssembly
{
    struct Dependencies
    {
        let favoriteRepository: IFavoriteBookRepository
        let detailsService: IBookDetailsService
    }

    static func makeModule(
        book: Book,
        isFavoriteButtonNeeded: Bool,
        dependencies: Dependencies
    ) -> UIViewController {

        let router = BookDetailsRouter()
        let interactor = BookDetailsInteractor(
            favoriteRepository: dependencies.favoriteRepository,
            detailsService: dependencies.detailsService
        )

        let viewModelBuilder = BookDetailsViewModelBuilder()
        let presenter = BookDetailsPresenter(
            book: book,
            interactor: interactor,
            router: router,
            viewModelBuilder: viewModelBuilder,
            isFavoriteButtonNeeded: isFavoriteButtonNeeded
        )

        let viewController = BookDetailsViewController(presenter: presenter)
        router.viewController = viewController

        return viewController
    }
}

