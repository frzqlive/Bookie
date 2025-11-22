import Foundation

protocol IBookDetailsPresenter: AnyObject
{
    func didLoad(ui: IBookDetailsView)
    func didTapRead()
    func didTapFavorite()
}

final class BookDetailsPresenter
{
    private weak var ui: IBookDetailsView?
    private var book: Book
    private let interactor: IBookDetailsInteractor
    private let router: IBookDetailsRouter
    private let viewModelBuilder: IBookDetailsViewModelBuilder
    private let isFavoriteButtonNeeded: Bool

    init(
        book: Book,
        interactor: IBookDetailsInteractor,
        router: IBookDetailsRouter,
        viewModelBuilder: IBookDetailsViewModelBuilder,
        isFavoriteButtonNeeded: Bool = true
    ) {
        self.book = book
        self.interactor = interactor
        self.router = router
        self.viewModelBuilder = viewModelBuilder
        self.isFavoriteButtonNeeded = isFavoriteButtonNeeded
    }
}

extension BookDetailsPresenter: IBookDetailsPresenter
{
    func didLoad(ui: IBookDetailsView) {
        self.ui = ui

        let viewModel = self.viewModelBuilder.make(from: book, isFavoriteButtonEnabled: isFavoriteButtonNeeded)

        if self.canFetchAdditionalDetails(for: book) {
            ui.update(.loading(viewModel))
            self.fetchFullDetails()
        } else {
            ui.update(.content(viewModel))
        }

        ui.didTapRead = { [weak self] in self?.didTapRead() }
        ui.didTapFavorite = { [weak self] in self?.didTapFavorite() }
    }

    func didTapRead() {
        self.router.openBook(book: self.book)
    }

    func didTapFavorite() {
        self.interactor.saveToFavorites(book: book) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success:
                    self.ui?.showFavoriteResult(.success)
                case .alreadyExists:
                    self.ui?.showFavoriteResult(.alreadyExists)
                case .error(let error):
                    self.ui?.showFavoriteResult(.error(error))
            }
        }
    }
}

private extension BookDetailsPresenter
{
    func fetchFullDetails() {
        self.interactor.fetchFullDetails(for: self.book) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fullBook):
                    self.book = fullBook
                    let updatedViewModel = self.viewModelBuilder.make(
                        from: fullBook,
                        isFavoriteButtonEnabled: self.isFavoriteButtonNeeded
                    )
                    self.ui?.update(.content(updatedViewModel))
                case .failure:
                    self.ui?.update(.error(AppStrings.BookDetails.loadingFailed))
            }
        }
    }

    func canFetchAdditionalDetails(for book: Book) -> Bool {
        return self.viewModelBuilder.needsMoreDetails(for: book)
    }
}

