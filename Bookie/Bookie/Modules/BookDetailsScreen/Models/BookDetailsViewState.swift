import Foundation

enum BookDetailsViewState
{
    case loading(BookDetailsViewModel)
    case content(BookDetailsViewModel)
    case error(String)
}


