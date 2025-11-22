import Foundation

enum AppStrings
{
    enum Gallery
    {
        static let title = "Галерея"
        static let emptyState = "Книги не найдены\nПопробуйте другой запрос"
    }

    enum SearchBar
    {
        static let placeholder = "Поиск книг"
    }

    enum MyBooks
    {
        static let title = "Мои книги"
        static let emptyState = "Нет сохраненных книг"
        static let readingStartedToday = "Чтение начато сегодня"
        static let oneReadingDay = "1 день чтения"
        static func readingDays(_ days: Int) -> String {
            "\(days) дней чтения"
        }
        static let wantToReadTitle = "Хочу прочитать"
        static let readingTitle = "Читаю"
        static let finishedTitle = "Прочитано"
        static let statusMenuTitle = "Статус"
    }

    enum BookDetails
    {
        static let title = "Детали"
        static let readButton = "Читать"
        static let addToFavoritesButton = "Добавить в избранное"
        static let addedToFavoritesButton = "Добавлено в избранное"
        static let alreadyInFavorites = "Книга уже есть в избранном"
        static let addingToFavoritesError = "Не удалось добавить в избранное"
        static let subjectsTitle = "Темы"
        static let firstPublishedTitle = "Первое издание"
        static let unknownAuthor = "Автор неизвестен"
        static let noDescription = "Описание отсутствует"
        static let pagesTitle = "Страницы"
        static let loadingFailed = "Не удалось загрузить детали книги"
    }

    enum Network
    {
        static let noDataMessage = "Данные не получены"
    }
}
