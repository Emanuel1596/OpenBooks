import SwiftUI

struct ContentView: View {
    @State var screen: AppScreen = .home
    @State var previousScreen: AppScreen = .home
    @State var selectedBookIndex: Int? = nil
    @State var searchText: String = ""
    @State var searchViewState: SearchViewState = .content
    @State var detailHomeActive: Bool = true

    @State var books: [Book] = mockBooks

    var body: some View {
        switch screen {

        case .home:
            HomeView(
                searchText: $searchText,
                books: books,
                onSearch: {
                    searchBooks()
                },
                onBookSelected: { index in
                    selectedBookIndex = index
                    previousScreen = .home
                    detailHomeActive = true
                    screen = .detail
                },
                onMyBooks: {
                    screen = .myBooks
                }
            )

        case .results:
            SearchResultsView(
                searchText: $searchText,
                books: books,
                state: searchViewState,
                onBack: {
                    screen = .home
                },
                onSearch: {
                    searchBooks()
                },
                onBookSelected: { index in
                    selectedBookIndex = index
                    previousScreen = .results
                    detailHomeActive = true
                    screen = .detail
                },
                onRetry: {
                    searchBooks()
                },
                onHome: {
                    screen = .home
                },
                onMyBooks: {
                    screen = .myBooks
                }
            )

        case .detail:
            if let index = selectedBookIndex {
                BookDetailView(
                    book: books[index],
                    homeActive: detailHomeActive,
                    onBack: {
                        screen = previousScreen
                    },
                    onSaveOrDelete: {
                        books[index].isSaved.toggle()
                        screen = .myBooks
                    },
                    onHome: {
                        screen = .home
                    },
                    onMyBooks: {
                        screen = .myBooks
                    }
                )
            } else {
                HomeView(
                    searchText: $searchText,
                    books: books,
                    onSearch: {
                        searchBooks()
                    },
                    onBookSelected: { index in
                        selectedBookIndex = index
                        previousScreen = .home
                        detailHomeActive = true
                        screen = .detail
                    },
                    onMyBooks: {
                        screen = .myBooks
                    }
                )
            }

        case .myBooks:
            MyBooksView(
                books: books,
                onBookSelected: { index in
                    selectedBookIndex = index
                    previousScreen = .myBooks
                    detailHomeActive = false
                    screen = .detail
                },
                onHome: {
                    screen = .home
                },
                onSearch: {
                    screen = .home
                }
            )
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

    screen = .results
    }
}
