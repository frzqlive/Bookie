import UIKit

final class MyBooksTableViewDataSource: NSObject, UITableViewDataSource
{
    private var sections: [MyBooksSectionViewModel]

    init(sections: [MyBooksSectionViewModel] = []) {
        self.sections = sections
    }

    func update(sections: [MyBooksSectionViewModel]) {
        self.sections = sections
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < self.sections.count else { return 0 }
        return self.sections[section].books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBooksTableViewCell.reuseIdentifier, for: indexPath) as? MyBooksTableViewCell else {
            return UITableViewCell()
        }

        let section = self.sections[safe: indexPath.section]
        let book = section?.books[safe: indexPath.row]
        if let book = book {
            cell.configure(with: book)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < self.sections.count else { return nil }
        let sectionModel = self.sections[section]
        return sectionModel.books.isEmpty ? nil : sectionModel.title
    }

    func status(for section: Int) -> ReadingStatus? {
        guard section >= 0, section < self.sections.count else { return nil }
        return self.sections[section].status
    }
}

private extension Array
{
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < self.count else { return nil }
        return self[index]
    }
}
