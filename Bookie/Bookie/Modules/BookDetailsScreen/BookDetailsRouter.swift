import UIKit
import SafariServices

protocol IBookDetailsRouter: AnyObject
{
    func openBook(book: Book)
}

final class BookDetailsRouter: IBookDetailsRouter
{
    weak var viewController: UIViewController?

    func openBook(book: Book) {
        let bookURLString = "\(APIConstants.openLibraryBaseURL)\(book.id)"
        guard let url = URL(string: bookURLString) else { return }

        guard let viewController = self.viewController else { return }
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
}

