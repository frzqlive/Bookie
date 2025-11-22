import Foundation

final class BookRepository: IBookRepository
{
    private let bookService: IBookService

    init(bookService: IBookService) {
        self.bookService = bookService
    }

    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        self.bookService.fetchBooks(completion: completion)
    }

    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        self.bookService.searchBooks(query: query, completion: completion)
    }
}

