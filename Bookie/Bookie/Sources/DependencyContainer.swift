import Foundation
import CoreData

protocol IDependencyContainer
{
    var bookRepository: IBookRepository { get }
    var favoriteBookRepository: IFavoriteBookRepository { get }
    var bookDetailsDependencies: BookDetailsAssembly.Dependencies { get }
    var bookViewModelBuilder: IBookViewModelBuilder { get }
}

final class DependencyContainer: IDependencyContainer
{
    init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Bookie")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
        return container
    }()

    private lazy var coreDataService: ICoreDataService = {
        CoreDataService(
            persistentContainer: self.persistentContainer,
            mapper: BookCoreDataAdapter()
        )
    }()

    private lazy var networkService: INetworkService = {
        NetworkService()
    }()

    private lazy var bookService: IBookService = {
        BookService(networkService: self.networkService)
    }()

    private lazy var bookDetailsService: IBookDetailsService = {
        BookDetailsService(networkService: self.networkService)
    }()

    lazy var bookRepository: IBookRepository = {
        BookRepository(bookService: self.bookService)
    }()

    lazy var favoriteBookRepository: IFavoriteBookRepository = {
        FavoriteBookRepository(
            coreDataService: self.coreDataService
        )
    }()

    lazy var bookViewModelBuilder: IBookViewModelBuilder = {
        BookViewModelBuilder()
    }()

    var bookDetailsDependencies: BookDetailsAssembly.Dependencies {
        BookDetailsAssembly.Dependencies(
            favoriteRepository: self.favoriteBookRepository,
            detailsService: self.bookDetailsService
        )
    }
}
