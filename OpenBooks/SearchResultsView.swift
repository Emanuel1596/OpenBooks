import SwiftUI

struct SearchResultsView: View {
    @Binding var searchText: String
    let books: [Book]
    let state: ResultsState

    let onBack: () -> Void
    let onSearch: () -> Void
    let onBookSelected: (Int) -> Void
    let onRetry: () -> Void
    let onHome: () -> Void
    let onMyBooks: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button {
                        onBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                    }

                    Text("Resultados")
                        .font(.largeTitle)
                        .bold()

                    SearchFieldView(
                        text: $searchText,
                        onSearch: onSearch
                    )

                    switch state {

                    case .loading:
                        LoadingResultsView()

                    case .content:
                        if searchText == "Orgullo y prejuicio" {
                            VStack(spacing: 0) {
                                ForEach(7..<10) { index in
                                    BookRowView(
                                        book: books[index]
                                    ) {
                                        onBookSelected(index)
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                ForEach(3..<7) { index in
                                    BookRowView(
                                        book: books[index]
                                    ) {
                                        onBookSelected(index)
                                    }
                                }
                            }
                        }

                    case .noResults:
                        NoResultsView()

                    case .error:
                        SearchErrorView(
                            onRetry: onRetry
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }

            BottomNavigationView(
                homeActive: true,
                onHome: onHome,
                onMyBooks: onMyBooks
            )
        }
    }
}

struct LoadingResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "hourglass")
                .font(.system(size: 50))
                .foregroundStyle(.gray)

            Text("Buscando libros...")
                .font(.system(size: 20))

            Text("Esto puede tardar unos segundos.")
                .foregroundStyle(.gray)

            Spacer()
        }
    }
}

struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundStyle(.gray)

            Text("No se encontraron libros")
                .font(.system(size: 20))
                .bold()

            Text("Intenta realizar otra búsqueda.")
                .foregroundStyle(.gray)

            Spacer()
        }
    }
}

struct SearchErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 50))
                .foregroundStyle(.gray)

            Text("No se pudieron cargar los libros")
                .font(.system(size: 20))
                .bold()

            Text(
                "Ocurrió un error al obtener los resultados. Intenta nuevamente."
            )
            .foregroundStyle(.gray)

            Button {
                onRetry()
            } label: {
                HStack {
                    Spacer()

                    Text("Intentar nuevamente")
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.vertical, 14)
                .background(.black)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
            }

            Spacer()
        }
    }
}
