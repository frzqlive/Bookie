import Foundation

struct BookViewModel
{
    let title: String
    let author: String
    let coverURL: URL?
    let subtitle: String?

    init(
        title: String,
        author: String,
        coverURL: URL?,
        subtitle: String? = nil
    ) {
        self.title = title
        self.author = author
        self.coverURL = coverURL
        self.subtitle = subtitle
    }
}
