import Foundation

final class FavoriteBookRepository: IFavoriteBookRepository
{
    private let coreDataService: ICoreDataService

    init(coreDataService: ICoreDataService) {
        self.coreDataService = coreDataService
    }

    func saveBook(_ book: Book, completion: @escaping (SaveFavoriteResult) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                if self.coreDataService.bookExists(with: book.id) {
                    DispatchQueue.main.async {
                        completion(.alreadyExists)
                    }
                    return
                }

                let normalizedBook = book.status == nil ? book.withStatus(.wantToRead) : book
                try self.coreDataService.saveBook(normalizedBook)
                DispatchQueue.main.async {
                    completion(.success)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }

    func fetchAllBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                let books = try self.coreDataService.fetchAllBooks()
                DispatchQueue.main.async {
                    completion(.success(books))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteBook(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                try self.coreDataService.deleteBook(with: id)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func updateBookStatus(id: String, status: ReadingStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                try self.coreDataService.updateBookStatus(with: id, status: status)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

