import Foundation

protocol IFavoriteBookRepository: AnyObject
{
    func saveBook(_ book: Book, completion: @escaping (SaveFavoriteResult) -> Void)
    func fetchAllBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    func deleteBook(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateBookStatus(id: String, status: ReadingStatus, completion: @escaping (Result<Void, Error>) -> Void)
}

