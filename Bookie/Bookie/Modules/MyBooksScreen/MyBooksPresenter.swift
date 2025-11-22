import Foundation

protocol IMyBooksPresenter: AnyObject
{
    func didLoad(ui: IMyBooksView?)
    func refresh()
    func didSelectBook(at index: IndexPath)
    func didDeleteBook(at index: IndexPath)
    func didChangeStatus(at index: IndexPath, to status: ReadingStatus)
}

final class MyBooksPresenter
{
    private weak var ui: IMyBooksView?
    private let interactor: IMyBooksInteractor
    private let router: IMyBooksRouter
    private let viewModelFactory: IMyBooksViewModelFactory
    private var state = MyBooksState()

    init(
        interactor: IMyBooksInteractor,
        router: IMyBooksRouter,
        viewModelFactory: IMyBooksViewModelFactory
    ) {
        self.interactor = interactor
        self.router = router
        self.viewModelFactory = viewModelFactory
    }
}

extension MyBooksPresenter: IMyBooksPresenter
{
    func didLoad(ui: IMyBooksView?) {
        self.ui = ui
        self.ui?.didSelectBook = { [weak self] index in
            self?.didSelectBook(at: index)
        }
        self.ui?.didDeleteBook = { [weak self] index in
            self?.didDeleteBook(at: index)
        }
        self.ui?.didChangeStatus = { [weak self] index, status in
            self?.didChangeStatus(at: index, to: status)
        }
        self.refresh()
    }

    func refresh() {
        self.ui?.showLoading()
        self.interactor.fetchBooks { [weak self] result in
            guard let self = self, let ui = self.ui else { return }
            ui.hideLoading()

            switch result {
                case .success(let books):
                    self.state.updateBooks(books)
                    self.updateUI()
                case .failure(let error):
                    ui.showError(error)
                    ui.showEmptyState(true)
            }
        }
    }

    func didSelectBook(at index: IndexPath) {
        guard let book = self.state.book(at: index) else { return }
        self.router.openBookDetails(book: book)
    }

    func didDeleteBook(at index: IndexPath) {
        guard let book = self.state.book(at: index) else { return }
        self.interactor.deleteBook(id: book.id) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success:
                    self.state.remove(book)
                    self.updateUI()
                case .failure(let error):
                    self.ui?.showError(error)
            }
        }
    }

    func didChangeStatus(at index: IndexPath, to status: ReadingStatus) {
        guard let book = self.state.book(at: index) else { return }
        let currentStatus = book.status ?? .wantToRead
        guard currentStatus != status else { return }

        self.interactor.updateBookStatus(id: book.id, status: status) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success:
                    self.state.applyStatusChange(for: book, to: status)
                    self.updateUI()
                case .failure(let error):
                    self.ui?.showError(error)
            }
        }
    }
}

private extension MyBooksPresenter
{
    func updateUI() {
        let data = self.state.sections()
        let viewModels = self.viewModelFactory.makeSections(from: data)
        self.ui?.showBooks(viewModels)
        self.ui?.showEmptyState(self.state.isEmpty)
    }
}

