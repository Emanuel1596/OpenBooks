import SwiftData

// Separa las operaciones de SwiftData de las vistas y de BooksState.
@MainActor
final class SavedBooksRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func savedBooks() throws -> [SavedBook] {
        try context.fetch(FetchDescriptor<SavedBook>())
    }

    @discardableResult
    func save(_ book: Book) throws -> Bool {
        // Dos pulsaciones del mismo libro no deben crear registros duplicados.
        guard try !savedBooks().contains(where: { $0.bookID == book.id }) else {
            return false
        }

        context.insert(SavedBook(book: book))
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            throw error
        }
    }

    @discardableResult
    func delete(_ book: Book) throws -> Bool {
        let matches = try savedBooks().filter { $0.bookID == book.id }
        guard !matches.isEmpty else { return false }

        for savedBook in matches {
            context.delete(savedBook)
        }

        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            throw error
        }
    }
}
