import Foundation

struct Book: Equatable
{
    let id: String
    let title: String
    let authors: [String]
    let coverID: Int?
    let coverURL: String?
    let year: Int?
    let description: String?
    let subjects: [String]
    let firstPublishDate: String?
    let numberOfPages: Int?
    let bookKey: String?
    let addedAt: Date?
    let status: ReadingStatus?
}

extension Book
{
    func withStatus(_ status: ReadingStatus?) -> Book {
        Book(
            id: self.id,
            title: self.title,
            authors: self.authors,
            coverID: self.coverID,
            coverURL: self.coverURL,
            year: self.year,
            description: self.description,
            subjects: self.subjects,
            firstPublishDate: self.firstPublishDate,
            numberOfPages: self.numberOfPages,
            bookKey: self.bookKey,
            addedAt: self.addedAt,
            status: status ?? self.status
        )
    }
}

extension Book
{
    init(dto: BookDTO) {
        self.init(
            id: dto.key,
            title: dto.title,
            authors: dto.authorName ?? [],
            coverID: dto.coverID,
            coverURL: Self.buildCoverURL(from: dto.coverID),
            year: dto.firstPublishYear,
            description: dto.description,
            subjects: [],
            firstPublishDate: nil,
            numberOfPages: nil,
            bookKey: dto.workKey?.first ?? dto.key,
            addedAt: nil,
            status: nil
        )
    }
}
