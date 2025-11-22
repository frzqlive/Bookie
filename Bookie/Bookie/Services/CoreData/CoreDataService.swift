import Foundation
import CoreData

protocol ICoreDataService: AnyObject
{
    func saveBook(_ book: Book) throws
    func fetchAllBooks(in context: NSManagedObjectContext) throws -> [Book]
    func fetchAllBooks() throws -> [Book]
    func deleteBook(with id: String) throws
    func bookExists(with id: String) -> Bool
    func updateBookStatus(with id: String, status: ReadingStatus) throws
    func performBackground(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataService: ICoreDataService
{
    private enum Constants
    {
        static let existenceCheckFetchLimit = 1
    }

    private let persistentContainer: NSPersistentContainer
    private let mapper: IBookCoreDataAdapter

    init(persistentContainer: NSPersistentContainer, mapper: IBookCoreDataAdapter) {
        self.persistentContainer = persistentContainer
        self.mapper = mapper
    }
}

extension CoreDataService
{
    private var viewContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }

    func saveBook(_ book: Book) throws {
        var thrownError: Error?
        self.viewContext.performAndWait {
            do {
                guard !self.bookExists(with: book.id, in: self.viewContext) else { return }

                let model = FavoriteBook(context: self.viewContext)
                self.mapper.toCoreData(book: book, model: model)
                try self.viewContext.save()
            } catch {
                thrownError = error
            }
        }

        if let error = thrownError {
            throw error
        }
    }

    func fetchAllBooks(in context: NSManagedObjectContext) throws -> [Book] {
        var result = Result<[Book], Error>.success([])
        context.performAndWait {
            do {
                let request: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                let objects = try context.fetch(request)
                let books = objects.map { self.mapper.toBook(model: $0) }
                result = .success(books)
            } catch {
                result = .failure(error)
            }
        }

        switch result {
            case .success(let books):
                return books
            case .failure(let error):
                throw error
        }
    }

    func fetchAllBooks() throws -> [Book] {
        return try self.fetchAllBooks(in: self.viewContext)
    }

    func deleteBook(with id: String) throws {
        var thrownError: Error?
        self.viewContext.performAndWait {
            do {
                let request = self.makeFetchRequest(for: id)
                if let model = try self.viewContext.fetch(request).first {
                    self.viewContext.delete(model)
                    try self.viewContext.save()
                }
            } catch {
                thrownError = error
            }
        }

        if let error = thrownError {
            throw error
        }
    }

    func updateBookStatus(with id: String, status: ReadingStatus) throws {
        var thrownError: Error?
        self.viewContext.performAndWait {
            do {
                let request = self.makeFetchRequest(for: id)
                if let model = try self.viewContext.fetch(request).first {
                    model.status = status.rawValue
                    try self.viewContext.save()
                }
            } catch {
                thrownError = error
            }
        }

        if let error = thrownError {
            throw error
        }
    }

    func bookExists(with id: String) -> Bool {
        var exists = false
        self.viewContext.performAndWait {
            exists = self.bookExists(with: id, in: self.viewContext)
        }
        return exists
    }

    func performBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
}

private extension CoreDataService
{
    func bookExists(with id: String, in context: NSManagedObjectContext) -> Bool {
        let request = self.makeFetchRequest(for: id)
        request.fetchLimit = Constants.existenceCheckFetchLimit

        do {
            return try context.count(for: request) > 0
        } catch {
            return false
        }
    }

    func makeFetchRequest(for id: String) -> NSFetchRequest<FavoriteBook> {
        let request: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return request
    }
}
