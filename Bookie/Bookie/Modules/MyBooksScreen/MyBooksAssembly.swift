import UIKit

enum MyBooksAssembly
{
    struct Dependencies
    {
        let router: IMyBooksRouter
        let interactor: IMyBooksInteractor
        let builder: IBookViewModelBuilder
    }

    static func makeModule(dependencies: Dependencies) -> UIViewController {
        let viewModelFactory = MyBooksViewModelFactory(builder: dependencies.builder)
        let presenter = MyBooksPresenter(
            interactor: dependencies.interactor,
            router: dependencies.router,
            viewModelFactory: viewModelFactory
        )
        return MyBooksViewController(presenter: presenter)
    }
}
