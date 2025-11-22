import UIKit

struct BookDetailsViewModel
{
    let title: String
    let authors: String
    let description: String
    let isDescriptionHidden: Bool
    let coverImageURL: URL?
    let isFavoriteButtonEnabled: Bool
    let metadata: String
    let isMetadataHidden: Bool
    let readButtonTitle: String
    let favoriteButtonTitle: String
}
