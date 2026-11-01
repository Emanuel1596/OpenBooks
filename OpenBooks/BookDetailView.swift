import SwiftUI

struct BookDetailView: View {
    let book: Book
    let homeActive: Bool


    let onSaveOrDelete: () -> Void
    let onHome: () -> Void
    let onMyBooks: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {


                    Text("Detalle del libro")
                        .foregroundStyle(Color("Ink"))
                        .font(.largeTitle)
                        .bold()

                    HStack {
                        Spacer()

                        LargeBookCoverView(book: book)

                        Spacer()
                    }

                    HStack {
                        Spacer()

                        VStack(spacing: 10) {
                            Text(book.title)
                                .foregroundStyle(Color("Ink"))
                                .font(.system(size: 24))
                                .bold()

                            Text(book.author)
                                .font(.system(size: 20))
                                .foregroundStyle(Color("Muted"))

                            if let year = book.year {
                                Text("Año: \(year)")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color("Muted"))
                            }
                        }

                        Spacer()
                    }

                    Button {
                        onSaveOrDelete()
                    } label: {
                        HStack {
                            Spacer()

                            if book.isSaved {
                                Text("Quitar de favoritos")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("Canvas"))
                            } else {
                                Text("Agregar a favoritos")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("Canvas"))
                            }

                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .background(Color("Accent"))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }

            BottomNavigationView(
                homeActive: homeActive,
                onHome: onHome,
                onMyBooks: onMyBooks
            )
        }
        .background(Color("Canvas").ignoresSafeArea())
    }
}

struct LargeBookCoverView: View {
    let book: Book

    var body: some View {
        BookCoverArtworkView(book: book)
            .frame(width: 220, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
