import Foundation

protocol IBookViewModelBuilder: AnyObject
{
    func make(from book: Book) -> BookViewModel
    func make(from books: [Book]) -> [BookViewModel]
}

final class BookViewModelBuilder: IBookViewModelBuilder
{
    func make(from book: Book) -> BookViewModel {
        BookViewModel(
            title: book.title,
            author: self.author(from: book),
            coverURL: self.coverURL(from: book)
        )
    }

    func make(from books: [Book]) -> [BookViewModel] {
        books.map { self.make(from: $0) }
    }
}

private extension BookViewModelBuilder
{
    func author(from book: Book) -> String {
        guard !book.authors.isEmpty else {
            return AppStrings.BookDetails.unknownAuthor
        }
        return book.authors.joined(separator: ", ")
    }

    func coverURL(from book: Book) -> URL? {
        guard let string = book.coverURL else { return nil }
        return URL(string: string)
    }
}
