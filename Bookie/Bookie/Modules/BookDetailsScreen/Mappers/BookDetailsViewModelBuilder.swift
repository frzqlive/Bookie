import Foundation
import UIKit

protocol IBookDetailsViewModelBuilder: AnyObject
{
    func make(from book: Book, isFavoriteButtonEnabled: Bool) -> BookDetailsViewModel
    func needsMoreDetails(for book: Book) -> Bool
}

final class BookDetailsViewModelBuilder: IBookDetailsViewModelBuilder
{
    func make(from book: Book, isFavoriteButtonEnabled: Bool) -> BookDetailsViewModel {
        let authors = book.authors.isEmpty
            ? AppStrings.BookDetails.unknownAuthor
            : book.authors.joined(separator: ", ")

        let coverURL = self.coverURL(from: book)

        let description = book.description ?? AppStrings.BookDetails.noDescription
        let isDescriptionHidden = description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || description == AppStrings.BookDetails.noDescription
        
        let metadata = self.makeMetadataText(
            firstPublishDate: book.firstPublishDate,
            subjects: book.subjects,
            numberOfPages: book.numberOfPages.map { "\($0)" }
        )
        let isMetadataHidden = metadata.isEmpty

        return BookDetailsViewModel(
            title: book.title,
            authors: authors,
            description: description,
            isDescriptionHidden: isDescriptionHidden,
            coverImageURL: coverURL,
            isFavoriteButtonEnabled: isFavoriteButtonEnabled,
            metadata: metadata,
            isMetadataHidden: isMetadataHidden,
            readButtonTitle: AppStrings.BookDetails.readButton,
            favoriteButtonTitle: AppStrings.BookDetails.addToFavoritesButton
        )
    }

    func needsMoreDetails(for book: Book) -> Bool {
        guard book.bookKey != nil else { return false }

        return !self.hasDescription(book.description)
            || book.subjects.isEmpty
            || book.numberOfPages == nil
            || book.firstPublishDate == nil
    }
}

private extension BookDetailsViewModelBuilder
{
    func coverURL(from book: Book) -> URL? {
        guard let coverURL = book.coverURL else { return nil }

        return URL(string: coverURL)
    }

    func hasDescription(_ description: String?) -> Bool {
        guard let description = description?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }

        return !description.isEmpty
    }

    func makeMetadataText(
        firstPublishDate: String?,
        subjects: [String],
        numberOfPages: String?
    ) -> String {
        var chunks: [String] = []

        if let date = firstPublishDate, !date.isEmpty {
            chunks.append("\(AppStrings.BookDetails.firstPublishedTitle): \(date)")
        }

        if !subjects.isEmpty {
            chunks.append("\(AppStrings.BookDetails.subjectsTitle): \(subjects.joined(separator: ", "))")
        }

        if let pages = numberOfPages, !pages.isEmpty {
            chunks.append("\(AppStrings.BookDetails.pagesTitle): \(pages)")
        }

        return chunks.joined(separator: "\n")
    }
}

