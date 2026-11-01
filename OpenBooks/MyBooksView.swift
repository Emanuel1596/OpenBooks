import SwiftUI

struct MyBooksView: View {
    let books: [Book]

    let onHome: () -> Void
    let onSearch: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Mis favoritos")
                    .foregroundStyle(Color("Ink"))
                    .font(.largeTitle)
                    .bold()

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)

            if hasSavedBooks() {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<books.count) { index in
                            if books[index].isSaved {
                                BookRowView(
                                    book: books[index],
                                    destination: index
                                )

                                if hasSavedBookAfter(index: index) {
                                    RoundedRectangle(cornerRadius: 0)
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Muted"))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                VStack(spacing: 0) {
                    Spacer()

                    EmptyMyBooksView(
                        onSearch: onSearch
                    )
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }

            BottomNavigationView(
                homeActive: false,
                onHome: onHome,
                onMyBooks: {}
            )
        }
        .background(Color("Canvas").ignoresSafeArea())
    }

    func hasSavedBooks() -> Bool {
        for index in 0..<books.count {
            if books[index].isSaved {
                return true
            }
        }

        return false
    }

    func hasSavedBookAfter(index: Int) -> Bool {
        for nextIndex in 0..<books.count {
            if nextIndex > index && books[nextIndex].isSaved {
                return true
            }
        }

        return false
    }
}

struct EmptyMyBooksView: View {
    let onSearch: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Spacer()

                Image(systemName: "book")
                    .font(.system(size: 60))
                    .foregroundStyle(Color("Muted"))

                Spacer()
            }

            HStack {
                Spacer()

                Text("Todavía no tienes favoritos")
                    .foregroundStyle(Color("Ink"))
                    .font(.system(size: 20))
                    .bold()

                Spacer()
            }

            HStack {
                Spacer()

                Text("Busca un libro y agrégalo a tus favoritos.")
                    .foregroundStyle(Color("Muted"))

                Spacer()
            }

            Button(action: onSearch) {
                Text("Buscar libros")
                    .font(.headline)
                    .foregroundStyle(Color("Canvas"))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 52)
                    .background(Color("Accent"), in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
    }
}
