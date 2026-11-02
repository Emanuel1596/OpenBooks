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
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color("Ink"))
                        .accessibilityAddTraits(.isHeader)

                    LargeBookCoverView(book: book)
                        .frame(maxWidth: .infinity)

                    Text(book.title)
                        .font(.system(.title2, design: .serif, weight: .bold))
                        .foregroundStyle(Color("Ink"))
                        .accessibilityAddTraits(.isHeader)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Información")
                            .font(.headline)
                            .foregroundStyle(Color("Ink"))
                            .accessibilityAddTraits(.isHeader)

                        HStack(alignment: .firstTextBaseline) {
                            Text("Autor")
                                .foregroundStyle(Color("Muted"))
                            Spacer(minLength: 12)
                            Text(book.author)
                                .foregroundStyle(Color("Ink"))
                                .multilineTextAlignment(.trailing)
                        }

                        if let year = book.year {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Año de publicación")
                                    .foregroundStyle(Color("Muted"))
                                Spacer(minLength: 12)
                                Text(year)
                                    .foregroundStyle(Color("Ink"))
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding(16)
                    .background(Color("Card"), in: RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sobre este libro")
                            .font(.headline)
                            .foregroundStyle(Color("Ink"))
                            .accessibilityAddTraits(.isHeader)

                        Text(book.synopsis ?? "Todavía no hay una descripción disponible para este libro.")
                            .font(.body)
                            .foregroundStyle(Color("Muted"))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Button(action: onSaveOrDelete) {
                        Text(book.isSaved ? "Quitar de favoritos" : "Agregar a favoritos")
                            .font(.headline)
                            .foregroundStyle(Color("Canvas"))
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 52)
                            .background(Color("Accent"), in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
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
