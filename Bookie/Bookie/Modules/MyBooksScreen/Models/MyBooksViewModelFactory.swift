import Foundation

protocol IMyBooksViewModelFactory: AnyObject
{
    func makeSections(from sections: [MyBooksSectionData]) -> [MyBooksSectionViewModel]
}

final class MyBooksViewModelFactory: IMyBooksViewModelFactory
{
    private let builder: IBookViewModelBuilder

    init(builder: IBookViewModelBuilder) {
        self.builder = builder
    }

    func makeSections(from sections: [MyBooksSectionData]) -> [MyBooksSectionViewModel] {
        sections.map { section in
            MyBooksSectionViewModel(
                status: section.status,
                title: title(for: section.status),
                books: section.books.map { book in
                    let base = builder.make(from: book)
                    return BookViewModel(
                        title: base.title,
                        author: base.author,
                        coverURL: base.coverURL,
                        subtitle: subtitle(for: book)
                    )
                }
            )
        }
    }
}

private extension MyBooksViewModelFactory
{
    func subtitle(for book: Book) -> String? {
        guard let addedAt = book.addedAt else { return nil }

        let calendar = Calendar.current
        let days = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: addedAt),
            to: calendar.startOfDay(for: Date())
        ).day ?? 0

        switch days {
            case ..<0:  return nil
            case 0:     return AppStrings.MyBooks.readingStartedToday
            case 1:     return AppStrings.MyBooks.oneReadingDay
            default:    return AppStrings.MyBooks.readingDays(days)
        }
    }

    func title(for status: ReadingStatus) -> String {
        switch status {
            case .wantToRead: return AppStrings.MyBooks.wantToReadTitle
            case .reading:    return AppStrings.MyBooks.readingTitle
            case .finished:   return AppStrings.MyBooks.finishedTitle
        }
    }
}
