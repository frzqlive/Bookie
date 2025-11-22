import UIKit

final class GalleryCollectionManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate
{
    private(set) var books: [BookViewModel] = []
    var didSelectBookAt: ((Int) -> Void)?

    func update(books: [BookViewModel]) {
        self.books = books
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionCell.reuseIdentifier, for: indexPath) as? GalleryCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: books[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectBookAt?(indexPath.row)
    }
}

