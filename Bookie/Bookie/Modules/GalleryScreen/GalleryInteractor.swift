import Foundation

enum GallerySearchState
{
    case idle
    case loading
    case completed(Result<[Book], Error>)
}

protocol IGalleryInteractor: AnyObject
{
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    func searchBooks(query: String, completion: @escaping (GallerySearchState) -> Void)
}

final class GalleryInteractor
{
    private enum Constants
    {
        static let debounceDelay: TimeInterval = 0.7
        static let minSymbolsForSearch = 2
    }

    private let bookRepository: IBookRepository
    private let searchQueue = DispatchQueue(label: "com.bookie.gallery.search")
    private var searchWorkItem: DispatchWorkItem?
    private var currentQuery: String = ""

    init(
        bookRepository: IBookRepository
    ) {
        self.bookRepository = bookRepository
    }

    deinit {
        let workItem = self.searchWorkItem
        self.searchWorkItem = nil
        workItem?.cancel()
    }
}

extension GalleryInteractor: IGalleryInteractor
{
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        self.bookRepository.fetchBooks(completion: completion)
    }

    func searchBooks(query: String, completion: @escaping (GallerySearchState) -> Void) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        searchQueue.async { [weak self] in
            guard let self = self else { return }

            self.currentQuery = trimmedQuery
            self.cancelSearch()

            guard trimmedQuery.count >= Constants.minSymbolsForSearch else {
                DispatchQueue.main.async {
                    completion(.idle)
                }
                return
            }

            DispatchQueue.main.async {
                completion(.loading)
            }

            let capturedQuery = trimmedQuery
            var workItem: DispatchWorkItem?
            workItem = DispatchWorkItem { [weak self] in
                guard let self = self,
                      let currentWorkItem = self.searchWorkItem,
                      currentWorkItem === workItem,
                      !currentWorkItem.isCancelled else { return }

                self.bookRepository.searchBooks(query: capturedQuery) { [weak self] result in
                    guard let self = self,
                          let currentWorkItem = self.searchWorkItem,
                          currentWorkItem === workItem,
                          !currentWorkItem.isCancelled else { return }

                    self.searchQueue.async {
                        guard self.currentQuery == capturedQuery else { return }
                        DispatchQueue.main.async {
                            completion(.completed(result))
                        }
                    }
                }
            }

            self.searchWorkItem = workItem
            if let workItem = workItem {
                DispatchQueue.global(qos: .userInitiated).asyncAfter(
                    deadline: .now() + Constants.debounceDelay,
                    execute: workItem
                )
            }
        }
    }
}

private extension GalleryInteractor
{
    func cancelSearch() {
        let workItem = self.searchWorkItem
        self.searchWorkItem = nil
        workItem?.cancel()
    }
}
