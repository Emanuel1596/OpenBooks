import SwiftUI

struct BookDetailView: View {
    let book: Book
    let homeActive: Bool
    let onSaveOrDelete: () -> Void
    let onHome: () -> Void
    let onMyBooks: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Detalle del libro")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color("Ink"))
                            .accessibilityAddTraits(.isHeader)

                        // Acceso visible a los datos que quedan debajo de la portada.
                        Button {
                            withAnimation {
                                scrollProxy.scrollTo("informacionLibro", anchor: .top)
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("Ver información y sinopsis")
                                Image(systemName: "arrow.down")
                                    .accessibilityHidden(true)
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color("Accent"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color("Card"), in: Capsule())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Desplaza el detalle hasta los datos y la descripción del libro")

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

                            DetailInformationRow(label: "Autor", value: book.author)

                            if let year = book.year {
                                DetailInformationRow(label: "Primera publicación", value: year)
                            }

                            if let genre = book.genre {
                                DetailInformationRow(label: "Género", value: genre)
                            }

                            if let originalLanguage = book.originalLanguage {
                                DetailInformationRow(label: "Idioma original", value: originalLanguage)
                            }

                            if let originalTitle = book.originalTitle {
                                DetailInformationRow(label: "Título original", value: originalTitle)
                            }
                        }
                        .font(.subheadline)
                        .padding(16)
                        .background(Color("Card"), in: RoundedRectangle(cornerRadius: 14))
                        .id("informacionLibro")

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

                        if !book.themes.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Temas principales")
                                    .font(.headline)
                                    .foregroundStyle(Color("Ink"))
                                    .accessibilityAddTraits(.isHeader)

                                Text(book.themes.joined(separator: " · "))
                                    .font(.subheadline)
                                    .foregroundStyle(Color("Muted"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }

            // La acción principal permanece visible aunque el detalle sea largo.
            Button(action: onSaveOrDelete) {
                Text(book.isSaved ? "Quitar de favoritos" : "Agregar a favoritos")
                    .font(.headline)
                    .foregroundStyle(Color("Canvas"))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 52)
                    .background(Color("Accent"), in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            BottomNavigationView(
                homeActive: homeActive,
                onHome: onHome,
                onMyBooks: onMyBooks
            )
        }
        .background(Color("Canvas").ignoresSafeArea())
    }
}

// Componente de presentación reutilizable para no duplicar filas de información.
private struct DetailInformationRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(Color("Muted"))
            Spacer(minLength: 12)
            Text(value)
                .foregroundStyle(Color("Ink"))
                .multilineTextAlignment(.trailing)
        }
    }
}
