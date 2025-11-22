import Foundation

protocol IBookDetailsInteractor: AnyObject
{
    func saveToFavorites(book: Book, completion: @escaping (SaveFavoriteResult) -> Void)
    func fetchFullDetails(for book: Book, completion: @escaping (Result<Book, Error>) -> Void)
}

final class BookDetailsInteractor: IBookDetailsInteractor
{
    private let favoriteRepository: IFavoriteBookRepository
    private let detailsService: IBookDetailsService

    init(
        favoriteRepository: IFavoriteBookRepository,
        detailsService: IBookDetailsService
    ) {
        self.favoriteRepository = favoriteRepository
        self.detailsService = detailsService
    }

    func saveToFavorites(book: Book, completion: @escaping (SaveFavoriteResult) -> Void) {
        self.favoriteRepository.saveBook(book, completion: completion)
    }

    func fetchFullDetails(for book: Book, completion: @escaping (Result<Book, Error>) -> Void) {
        guard let bookKey = book.bookKey else {
            completion(.success(book))
            return
        }

        self.detailsService.fetchFullDetails(for: bookKey, baseBook: book) { result in
            switch result {
                case .success(let fullBook):
                    completion(.success(fullBook))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
