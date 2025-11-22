import UIKit

final class MyBooksTableViewDelegate: NSObject, UITableViewDelegate
{
    private enum Constants
    {
        static let rowHeight: CGFloat = 100
        static let deleteImageName = "trash"
    }

    var didSelectBookAt: ((IndexPath) -> Void)?
    var didDeleteBookAt: ((IndexPath) -> Void)?
    var didChangeStatusAt: ((IndexPath, ReadingStatus) -> Void)?
    var statusProvider: ((IndexPath) -> ReadingStatus?)?
    var statusMenuOptions: [(ReadingStatus, String)] = []

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.didSelectBookAt?(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.didDeleteBookAt?(indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: Constants.deleteImageName)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actions = self.makeStatusActions(for: indexPath)
        guard !actions.isEmpty else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: AppStrings.MyBooks.statusMenuTitle, children: actions)
        }
    }
}

private extension MyBooksTableViewDelegate
{
    @available(iOS 13.0, *)
    func makeStatusActions(for indexPath: IndexPath) -> [UIAction] {
        guard !self.statusMenuOptions.isEmpty else { return [] }
        let currentStatus = self.statusProvider?(indexPath)
        return self.statusMenuOptions.map { status, title in
            UIAction(title: title, state: status == currentStatus ? .on : .off) { [weak self] _ in
                self?.didChangeStatusAt?(indexPath, status)
            }
        }
    }
}
