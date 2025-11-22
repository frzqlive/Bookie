import Foundation

protocol IGalleryPresenter: AnyObject
{
    func didLoad(ui: IGalleryView?)
    func refresh()
    func didSelectBook(at index: Int)
    func didChangeSearchText(_ text: String)
}

final class GalleryPresenter
{
    private weak var ui: IGalleryView?
    private let interactor: IGalleryInteractor
    private let router: IGalleryRouter
    private let viewModelBuilder: IBookViewModelBuilder

    private var allBooks: [Book] = []
    private var filteredBooks: [Book] = []
    private var isLoading = false
    private var isFiltering = false

    init(
        interactor: IGalleryInteractor,
        router: IGalleryRouter,
        viewModelBuilder: IBookViewModelBuilder
    ) {
        self.interactor = interactor
        self.router = router
        self.viewModelBuilder = viewModelBuilder
    }
}

extension GalleryPresenter: IGalleryPresenter
{
    func didLoad(ui: IGalleryView?) {
        self.ui = ui
        self.ui?.didSelectBook = { [weak self] index in
            self?.didSelectBook(at: index)
        }
        self.ui?.didChangeSearchText = { [weak self] text in
            self?.didChangeSearchText(text)
        }
        fetchBooks()
    }

    func refresh() {
        fetchBooks()
    }

    func didSelectBook(at index: Int) {
        let source = self.isFiltering ? self.filteredBooks : self.allBooks
        guard index >= 0, index < source.count else { return }
        let book = source[index]
        self.router.openBookDetails(book: book)
    }

    func didChangeSearchText(_ text: String) {
        self.interactor.searchBooks(query: text) { [weak self] state in
            guard let self = self else { return }

            switch state {
                case .idle:
                    self.isFiltering = false
                    self.filteredBooks = []
                    self.show(self.allBooks)
                case .loading:
                    self.isFiltering = true
                    self.ui?.showLoading()
                case .completed(let result):
                    switch result {
                        case .success(let books):
                            self.isFiltering = true
                            self.filteredBooks = books
                            self.show(books)
                        case .failure(let error):
                            self.isFiltering = false
                            self.filteredBooks = []
                            self.show(error)
                    }
            }
        }
    }
}

private extension GalleryPresenter
{
    func fetchBooks() {
        guard !self.isLoading else { return }

        self.isLoading = true
        self.ui?.showLoading()

        self.interactor.fetchBooks { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
                case .success(let books):
                    self.isFiltering = false
                    self.filteredBooks = []
                    self.allBooks = books
                    self.show(books)
                case .failure(let error):
                    self.show(error)
            }
        }
    }

    func show(_ books: [Book]) {
        let viewModels = self.viewModelBuilder.make(from: books)
        self.ui?.showBooks(with: viewModels)
        self.ui?.showEmptyState(viewModels.isEmpty)
    }

    func show(_ error: Error) {
        self.ui?.showError(error)
        self.ui?.showEmptyState(true)
    }
}

