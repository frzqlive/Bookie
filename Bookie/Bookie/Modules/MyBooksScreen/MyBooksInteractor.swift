import Foundation

protocol IMyBooksInteractor: AnyObject
{
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    func deleteBook(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateBookStatus(id: String, status: ReadingStatus, completion: @escaping (Result<Void, Error>) -> Void)
}

final class MyBooksInteractor: IMyBooksInteractor
{
    private let favoriteRepository: IFavoriteBookRepository

    init(favoriteRepository: IFavoriteBookRepository) {
        self.favoriteRepository = favoriteRepository
    }

    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        self.favoriteRepository.fetchAllBooks(completion: completion)
    }

    func deleteBook(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.favoriteRepository.deleteBook(id: id, completion: completion)
    }

    func updateBookStatus(id: String, status: ReadingStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        self.favoriteRepository.updateBookStatus(id: id, status: status, completion: completion)
    }
}

