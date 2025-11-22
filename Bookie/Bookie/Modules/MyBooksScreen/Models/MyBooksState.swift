import Foundation
import UIKit

struct MyBooksSectionData
{
    let status: ReadingStatus
    let books: [Book]
}

struct MyBooksState
{
    private var books: [Book] = []
    private let sectionsOrder = ReadingStatus.orderedCases

    mutating func updateBooks(_ books: [Book]) {
        self.books = books
    }

    mutating func remove(_ book: Book) {
        self.books.removeAll { $0.id == book.id }
    }

    mutating func applyStatusChange(for book: Book, to newStatus: ReadingStatus) {
        let updatedBook = book.withStatus(newStatus)
        self.books = self.books.map { $0.id == book.id ? updatedBook : $0 }
    }

    func book(at index: IndexPath) -> Book? {
        let sections = self.buildSections()
        guard index.section >= 0, index.section < sections.count else { return nil }
        let section = sections[index.section]
        guard index.row >= 0, index.row < section.books.count else { return nil }
        return section.books[index.row]
    }

    func sections() -> [MyBooksSectionData] {
        self.buildSections()
    }

    var isEmpty: Bool {
        self.books.isEmpty
    }

    private func buildSections() -> [MyBooksSectionData] {
        let grouped = Dictionary(grouping: self.books) { $0.status ?? .wantToRead }
        return self.sectionsOrder.map { status in
            let sorted = (grouped[status] ?? []).sorted { lhs, rhs in
                lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            }
            return MyBooksSectionData(status: status, books: sorted)
        }
    }
}
