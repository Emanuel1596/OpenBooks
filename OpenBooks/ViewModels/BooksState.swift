import Observation

@Observable
class BooksState {
    var books: [Book] = mockBooks

    func toggleSaved(at index: Int) {
        books[index].isSaved.toggle()
    }
}
