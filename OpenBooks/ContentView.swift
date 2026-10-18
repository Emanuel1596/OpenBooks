import SwiftUI

struct ContentView: View {
    @State var path: [Int] = []
    @State var showingMyBooks: Bool = false
    @State var searchText: String = ""
    @State var searchViewState: SearchViewState = .content
    @State var booksState = BooksState()

    let resultsRoute: Int = -1
    let searchRoute: Int = -2

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if showingMyBooks {
                    MyBooksView(
                        books: booksState.books,
                        onHome: {
                            showingMyBooks = false
                        },
                        onSearch: {
                            showingMyBooks = false
                            path.append(searchRoute)
                        }
                    )
                } else {
                    HomeView(
                        books: booksState.books,
                        onOpenSearch: {
                            path.append(searchRoute)
                        },
                        onMyBooks: {
                            showingMyBooks = true
                        }
                    )
                }
            }
            .navigationDestination(for: Int.self) { route in
                if route == searchRoute {
                    SearchView(
                        searchText: $searchText,
                        onSearch: {
                            searchBooks()
                        }
                    )
                } else if route == resultsRoute {
                    SearchResultsView(
                        searchText: searchText,
                        books: booksState.books,
                        state: searchViewState,
                        onOpenSearch: {
                            path.append(searchRoute)
                        },
                        onRetry: {
                            searchBooks()
                        },
                        onHome: {
                            path = []
                            showingMyBooks = false
                        },
                        onMyBooks: {
                            path = []
                            showingMyBooks = true
                        }
                    )
                } else {
                    BookDetailView(
                        book: booksState.books[route],
                        homeActive: !showingMyBooks,

                        onSaveOrDelete: {
                            booksState.books[route].isSaved.toggle()
                            path = []
                            showingMyBooks = true
                        },
                        onHome: {
                            path = []
                            showingMyBooks = false
                        },
                        onMyBooks: {
                            path = []
                            showingMyBooks = true
                        }
                    )
                }
            }
        }
    }

    func searchBooks() {
        if searchText == "Harry Potter" {
            searchViewState = .content
        } else if searchText == "Orgullo y prejuicio" {
            searchViewState = .content
        } else {
            searchViewState = .noResults
        }

        path = [resultsRoute]
    }
}
