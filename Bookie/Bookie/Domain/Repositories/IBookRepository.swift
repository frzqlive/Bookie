import Foundation

protocol IBookRepository: AnyObject
{
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void)
}
