import SwiftUI

struct BookDetailView: View {
    let book: Book
    let homeActive: Bool
    let onSaveOrDelete: () -> Void
    let onHome: () -> Void
    let onMyBooks: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Toda la ficha se consulta desplazando la pantalla de forma natural.
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Detalle del libro")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color("Ink"))
                        .accessibilityAddTraits(.isHeader)
                        .padding(.bottom, 20)

                    LargeBookCoverView(book: book)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)

                    Text(book.title)
                        .font(.system(.title2, design: .serif, weight: .bold))
                        .foregroundStyle(Color("Ink"))
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityAddTraits(.isHeader)
                        .padding(.bottom, 22)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Información")
                            .font(.headline)
                            .foregroundStyle(Color("Ink"))
                            .accessibilityAddTraits(.isHeader)
                            .padding(.bottom, 2)

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
                            // Los títulos extensos tienen toda la anchura para no quedar apretados.
                            DetailInformationRow(label: "Título original", value: originalTitle, stacked: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color("Card"), in: RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom, 28)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sobre este libro")
                            .font(.headline)
                            .foregroundStyle(Color("Ink"))
                            .accessibilityAddTraits(.isHeader)

                        Text(book.synopsis ?? "Todavía no hay una descripción disponible para este libro.")
                            .font(.body)
                            .foregroundStyle(Color("Muted"))
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 26)

                    if !book.themes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Temas principales")
                                .font(.headline)
                                .foregroundStyle(Color("Ink"))
                                .accessibilityAddTraits(.isHeader)

                            Text(book.themes.joined(separator: " · "))
                                .font(.subheadline)
                                .foregroundStyle(Color("Muted"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 36)
            }

            // El botón de favoritos permanece accesible sin ocultar el final de la ficha.
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

// Reutiliza el mismo estilo para los datos de la ficha.
private struct DetailInformationRow: View {
    let label: String
    let value: String
    var stacked: Bool = false

    var body: some View {
        Group {
            if stacked {
                VStack(alignment: .leading, spacing: 6) {
                    Text(label)
                        .foregroundStyle(Color("Muted"))
                    Text(value)
                        .foregroundStyle(Color("Ink"))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(label)
                        .foregroundStyle(Color("Muted"))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 8)
                    Text(value)
                        .foregroundStyle(Color("Ink"))
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .font(.subheadline)
    }
}
