import Foundation

protocol IBookDetailsService: AnyObject
{
    func fetchFullDetails(
        for bookKey: String,
        baseBook: Book,
        completion: @escaping (Result<Book, Error>) -> Void
    )
}

final class BookDetailsService: IBookDetailsService
{
    private let networkService: INetworkService
    private let decoder: JSONDecoder

    init(networkService: INetworkService) {
        self.networkService = networkService
        self.decoder = JSONDecoder()
    }

    func fetchFullDetails(
        for bookKey: String,
        baseBook: Book,
        completion: @escaping (Result<Book, Error>) -> Void
    ) {
        let normalizedKey = self.normalizeBookKey(bookKey)
        let urlString = "\(APIConstants.openLibraryBaseURL)\(normalizedKey).json"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(
                domain: APIConstants.ErrorDomain.bookDetailsService,
                code: APIConstants.unknownErrorCode,
                userInfo: [NSLocalizedDescriptionKey: APIConstants.ErrorMessage.invalidURL]
            )))
            return
        }

        self.networkService.performRequest(url: url) { result in
            switch result {
                case .success(let data):
                    do {
                        let bookDetails = try self.decoder.decode(BookFullDetailsDTO.self, from: data)
                        let bookEntity = self.mapToBook(bookDetails: bookDetails, baseBook: baseBook, bookKey: normalizedKey)
                        DispatchQueue.main.async {
                            completion(.success(bookEntity))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
            }
        }
    }
}

private extension BookDetailsService
{
    func normalizeBookKey(_ key: String) -> String {
        if key.hasPrefix("/works/") {
            return key
        } else if key.hasPrefix("/") {
            return "/works\(key)"
        } else {
            return "/works/\(key)"
        }
    }

    func mapToBook(bookDetails: BookFullDetailsDTO, baseBook: Book, bookKey: String) -> Book {
        let description = bookDetails.description?.value ?? baseBook.description
        let subjects = bookDetails.subjects ?? baseBook.subjects
        let firstPublishDate = bookDetails.firstPublishDate ?? baseBook.firstPublishDate
        let resolvedCoverID = baseBook.coverID ?? bookDetails.covers?.first
        let coverURL = baseBook.coverURL ?? Book.buildCoverURL(from: resolvedCoverID)

        return Book(
            id: baseBook.id,
            title: baseBook.title,
            authors: baseBook.authors.isEmpty ? [] : baseBook.authors,
            coverID: resolvedCoverID,
            coverURL: coverURL,
            year: baseBook.year,
            description: description,
            subjects: subjects,
            firstPublishDate: firstPublishDate,
            numberOfPages: bookDetails.numberOfPages ?? baseBook.numberOfPages,
            bookKey: bookKey,
            addedAt: baseBook.addedAt,
            status: baseBook.status
        )
    }
}

