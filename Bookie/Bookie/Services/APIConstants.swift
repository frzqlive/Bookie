import Foundation

enum APIConstants
{
    static let openLibraryBaseURL = "https://openlibrary.org"
    static let openLibrarySearchURL = "\(openLibraryBaseURL)/search.json"
    static let coversBaseURL = "https://covers.openlibrary.org/b/id/"
    static let coverSuffix = "-L.jpg"

    static let defaultQuery = "fantasy"
    static let searchLimit = "30"
    static let searchFields = "key,title,author_name,cover_i,work_key"

    static let successStatusCodeRange = 200...299
    static let unknownErrorCode = 0

    enum ErrorDomain
    {
        static let networkService = "NetworkService"
        static let bookService = "BookService"
        static let bookDetailsService = "BookDetailsService"
    }

    enum ErrorMessage
    {
        static let invalidURL = "Invalid URL"
        static let decodingError = "Failed to decode response"
    }
}

