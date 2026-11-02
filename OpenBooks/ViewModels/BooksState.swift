import Observation

@Observable
final class BooksState {
    var books: [Book] = mockBooks

    func toggleSaved(at index: Int) {
        guard books.indices.contains(index) else { return }
        books[index].isSaved.toggle()
    }
}
