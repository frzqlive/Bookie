import UIKit

enum GalleryAssembly
{
    struct Dependencies
    {
        let router: IGalleryRouter
        let interactor: IGalleryInteractor
        let viewModelBuilder: IBookViewModelBuilder
    }

    static func makeModule(dependencies: Dependencies) -> UIViewController {
        let presenter = GalleryPresenter(
            interactor: dependencies.interactor,
            router: dependencies.router,
            viewModelBuilder: dependencies.viewModelBuilder
        )
        return GalleryViewController(presenter: presenter)
    }
}
