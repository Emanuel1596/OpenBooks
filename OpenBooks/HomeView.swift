import SwiftUI

struct HomeView: View {
    @Binding var searchText: String
    let books: [Book]
    let onSearch: () -> Void
    let onBookSelected: (Int) -> Void
    let onMyBooks: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("OpenBooks")
                        .font(.largeTitle)
                        .bold()

                    SearchFieldView(
                        text: $searchText,
                        onSearch: onSearch
                    )

                    Text("Libros")
                        .font(.system(size: 24))
                        .bold()

                    VStack(spacing: 0) {
                        ForEach(0..<3) { index in
                            BookRowView(
                                book: books[index]
                            ) {
                                onBookSelected(index)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }

            BottomNavigationView(
                homeActive: true,
                onHome: {},
                onMyBooks: onMyBooks
            )
        }
    }
}

struct SearchFieldView: View {
    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.gray)

            HStack(spacing: 12) {
                Button {
                    onSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                }

                TextField(text: $text) {
                    Text("Buscar libros")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 13)
            )
            .padding(1)
        }
    }
}

struct BookRowView: View {
    let book: Book
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 16) {
                SmallBookCoverView(
                    hasCover: book.hasCover
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundStyle(.black)

                    Text(book.author)
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
            }
            .padding(.vertical, 12)
        }
    }
}

struct SmallBookCoverView: View {
    let hasCover: Bool

    var body: some View {
        if hasCover {
            Image(systemName: "xmark")
                .font(.system(size: 24))
                .foregroundStyle(.black)
                .frame(width: 84, height: 108)
                .background(.gray)
                .clipShape(
                    RoundedRectangle(cornerRadius: 3)
                )
        } else {
            VStack(spacing: 4) {
                Image(systemName: "book")
                    .font(.system(size: 20))

                Text("Sin portada")
                    .font(.system(size: 13))
            }
            .foregroundStyle(.black)
            .frame(width: 84, height: 108)
            .background(.gray)
            .clipShape(
                RoundedRectangle(cornerRadius: 3)
            )
        }
    }
}

struct BottomNavigationView: View {
    let homeActive: Bool
    let onHome: () -> Void
    let onMyBooks: () -> Void

    var body: some View {
        HStack {
            Spacer()

            Button {
                onHome()
            } label: {
                VStack(spacing: 4) {
                    if homeActive {
                        Image(systemName: "house.fill")
                            .font(.system(size: 24))
                    } else {
                        Image(systemName: "house")
                            .font(.system(size: 24))
                    }

                    Text("Inicio")
                        .font(.system(size: 13))
                }
                .foregroundStyle(.black)
            }

            Spacer()
            Spacer()

            Button {
                onMyBooks()
            } label: {
                VStack(spacing: 4) {
                    if homeActive {
                        Image(systemName: "book")
                            .font(.system(size: 24))
                    } else {
                        Image(systemName: "book.fill")
                            .font(.system(size: 24))
                    }

                    Text("Mis libros")
                        .font(.system(size: 13))
                }
                .foregroundStyle(.black)
            }

            Spacer()
        }
        .padding(.vertical, 10)
    }
}
