import Foundation

protocol IBookService: AnyObject
{
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void)
}

final class BookService: IBookService
{
    private let networkService: INetworkService
    private let decoder: JSONDecoder

    init(networkService: INetworkService) {
        self.networkService = networkService
        self.decoder = JSONDecoder()
    }

    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        self.search(query: "subject:\(APIConstants.defaultQuery)", completion: completion)
    }

    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            completion(.success([]))
            return
        }

        self.search(query: trimmedQuery, completion: completion)
    }
}

private extension BookService
{
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        var components = URLComponents(string: APIConstants.openLibrarySearchURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "fields", value: APIConstants.searchFields),
            URLQueryItem(name: "limit", value: APIConstants.searchLimit)
        ]

        guard let url = components?.url else {
            let error = NSError(
                domain: APIConstants.ErrorDomain.bookService,
                code: APIConstants.unknownErrorCode,
                userInfo: [NSLocalizedDescriptionKey: APIConstants.ErrorMessage.invalidURL]
            )
            completion(.failure(error))
            return
        }

        self.networkService.performRequest(url: url) { result in
            switch result {
                case .success(let data):
                    do {
                        let response = try self.decoder.decode(BookSearchResponseDTO.self, from: data)
                        let books = response.docs.map { Book(dto: $0) }
                        DispatchQueue.main.async {
                            completion(.success(books))
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
