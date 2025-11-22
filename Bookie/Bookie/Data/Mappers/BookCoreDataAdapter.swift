import Foundation
import CoreData

protocol IBookCoreDataAdapter: AnyObject
{
    func toCoreData(book: Book, model: FavoriteBook)
    func toBook(model: FavoriteBook) -> Book
}

final class BookCoreDataAdapter: IBookCoreDataAdapter
{
    private enum Constants
    {
        static let authorSeparator: String = ", "
        static let subjectsSeparator: String = " | "
        static let invalidInt32Value: Int32 = 0
        static let minValidInt32Value: Int32 = 1
    }

    func toCoreData(book: Book, model: FavoriteBook) {
        model.id = book.id
        model.title = book.title
        model.author = book.authors.joined(separator: Constants.authorSeparator)
        model.year = book.year.map(Int32.init) ?? Constants.invalidInt32Value
        model.bookDescription = book.description
        model.coverID = book.coverID.map(Int32.init) ?? Constants.invalidInt32Value
        model.coverURL = book.coverURL
        model.subjects = book.subjects.isEmpty ? nil : book.subjects.joined(separator: Constants.subjectsSeparator)
        model.firstPublishDate = book.firstPublishDate
        model.status = book.status?.rawValue

        if model.dateAdded == nil {
            model.dateAdded = book.addedAt ?? Date()
        }
    }

    func toBook(model: FavoriteBook) -> Book {
        Book(
            id: model.id ?? "",
            title: model.title ?? "",
            authors: model.author?.components(separatedBy: Constants.authorSeparator) ?? [],
            coverID: model.coverID >= Constants.minValidInt32Value ? Int(model.coverID) : nil,
            coverURL: model.coverURL,
            year: model.year >= Constants.minValidInt32Value ? Int(model.year) : nil,
            description: model.bookDescription,
            subjects: model.subjects?.components(separatedBy: Constants.subjectsSeparator) ?? [],
            firstPublishDate: model.firstPublishDate,
            numberOfPages: nil,
            bookKey: nil,
            addedAt: model.dateAdded,
            status: ReadingStatus(rawValue: model.status ?? "")
        )
    }
}
