import UIKit

final class AppCoordinator
{
    private enum Constants
    {
        static let galleryTabTitle = AppStrings.Gallery.title
        static let galleryTabImage = "book"
        static let galleryTabTag = 0
        static let myBooksTabTitle = AppStrings.MyBooks.title
        static let myBooksTabImage = "star.fill"
        static let myBooksTabTag = 1
    }

    private let window: UIWindow
    private let tabBarController = UITabBarController()
    private let container: IDependencyContainer

    init(window: UIWindow, container: IDependencyContainer) {
        self.window = window
        self.container = container
    }

    func start() {
        let galleryNav = self.setupGalleryModule()
        let myBooksNav = self.setupMyBooksModule()

        self.tabBarController.viewControllers = [galleryNav, myBooksNav]
        self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
    }
}

private extension AppCoordinator
{
    func setupGalleryModule() -> UINavigationController {
        let galleryNav = UINavigationController()
        let galleryRouter = GalleryRouter(
            navigationController: galleryNav,
            detailsDependencies: self.container.bookDetailsDependencies
        )
        let galleryInteractor = GalleryInteractor(
            bookRepository: self.container.bookRepository
        )

        let galleryDeps = GalleryAssembly.Dependencies(
            router: galleryRouter,
            interactor: galleryInteractor,
            viewModelBuilder: self.container.bookViewModelBuilder
        )
        let galleryVC = GalleryAssembly.makeModule(dependencies: galleryDeps)

        galleryNav.viewControllers = [galleryVC]
        galleryNav.tabBarItem = UITabBarItem(
            title: Constants.galleryTabTitle,
            image: UIImage(systemName: Constants.galleryTabImage),
            tag: Constants.galleryTabTag
        )

        return galleryNav
    }

    func setupMyBooksModule() -> UINavigationController {
        let myBooksNav = UINavigationController()
        let myBooksRouter = MyBooksRouter(
            navigationController: myBooksNav,
            detailsDependencies: self.container.bookDetailsDependencies
        )
        let myBooksInteractor = MyBooksInteractor(
            favoriteRepository: self.container.favoriteBookRepository
        )

        let myBooksDeps = MyBooksAssembly.Dependencies(
            router: myBooksRouter,
            interactor: myBooksInteractor,
            builder: self.container.bookViewModelBuilder
        )
        let myBooksVC = MyBooksAssembly.makeModule(dependencies: myBooksDeps)

        myBooksNav.viewControllers = [myBooksVC]
        myBooksNav.tabBarItem = UITabBarItem(
            title: Constants.myBooksTabTitle,
            image: UIImage(systemName: Constants.myBooksTabImage),
            tag: Constants.myBooksTabTag
        )

        return myBooksNav
    }
}

