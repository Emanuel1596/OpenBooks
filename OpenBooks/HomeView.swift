import SwiftUI

// Diseño editorial de OpenBooks con recursos de la referencia aprobada.

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var showingAllSuggestions = false

    let books: [Book]
    let onOpenSearch: () -> Void
    let onMyBooks: () -> Void

    // Se utilizan índices existentes para conservar la búsqueda y el estado compartido.
    // Así no cambiamos MockBooks ni las rutas usadas por las pruebas.
    private var featuredIndices: [Int] { [3, 2, 7] }

    private var visibleIndices: [Int] {
        let main = featuredIndices.filter { books.indices.contains($0) }
        if showingAllSuggestions {
            return main + books.indices.filter { !main.contains($0) }
        }
        return main
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 19) {
                    if dynamicTypeSize.isAccessibilitySize {
                        // El texto real de SwiftUI se adapta cuando Dynamic Type es muy grande.
                        VStack(alignment: .leading, spacing: 10) {
                            Text("OpenBooks")
                                .font(.system(.title, design: .serif, weight: .semibold))
                            Text("Encuentra tu próximo libro")
                                .font(.system(.title, design: .serif, weight: .semibold))
                        }
                        .foregroundStyle(Color("Ink"))
                        .padding(.top, 12)
                    } else {
                        // Recurso extraído directamente del boceto aprobado:
                        // mismo gato, dos libros y lámpara; solo cambia la iluminación.
                        Image(colorScheme == .dark ? "HeroReferenceNight" : "HeroReferenceDay")
                            .resizable()
                            .aspectRatio(494.0 / 341.0, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .accessibilityLabel("OpenBooks")
                            .accessibilityValue("Encuentra tu próximo libro")
                            .accessibilityAddTraits(.isHeader)
                    }

                    Button(action: onOpenSearch) {
                        HStack(spacing: 15) {
                            Image(systemName: "magnifyingglass")
                                .font(.title3.weight(.regular))
                            Text("Buscar libros")
                                .font(.body)
                            Spacer()
                        }
                        .foregroundStyle(Color("Ink"))
                        .padding(.horizontal, 20)
                        .frame(minHeight: 54)
                        .background(Color("SearchSurface"), in: Capsule())
                        .overlay(Capsule().stroke(Color("Border"), lineWidth: 0.8))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Buscar libros")
                    .accessibilityHint("Abre la pantalla de búsqueda")

                    VStack(alignment: .leading, spacing: 18) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Sugerencias")
                                .font(.system(.title2, design: .serif, weight: .semibold))
                                .foregroundStyle(Color("Ink"))
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                            Button {
                                showingAllSuggestions.toggle()
                            } label: {
                                HStack(spacing: 3) {
                                    Text(showingAllSuggestions ? "Ver menos" : "Ver todo")
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                }
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Color("Accent"))
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Muestra u oculta los demás libros de prueba")
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 3), spacing: 20) {
                            ForEach(visibleIndices, id: \.self) { index in
                                NavigationLink(value: index) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        editorialCover(for: index)
                                            .aspectRatio(138.0 / 178.0, contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 11))

                                        Text(shortTitle(for: index))
                                            .font(.subheadline.weight(.medium))
                                            .foregroundStyle(Color("Ink"))
                                            .lineLimit(3)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, alignment: .top)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .top)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(books[index].title)
                                .accessibilityHint("Abre el detalle del libro")
                            }
                        }
                    }
                    .padding(.top, 9)
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)

            BottomNavigationView(homeActive: true, onHome: {}, onMyBooks: onMyBooks)
        }
        .background(Color("Canvas").ignoresSafeArea())
    }

    private func shortTitle(for index: Int) -> String {
        if index == 3 { return "Harry Potter" }
        return books[index].title
    }

    @ViewBuilder
    private func editorialCover(for index: Int) -> some View {
        // Son exactamente los recortes de las tres portadas del boceto aprobado.
        // Las imágenes de Inicio son ilustrativas y no alteran hasCover en el modelo.
        if index == 3 {
            Image("EditorialHarry").resizable().scaledToFit()
        } else if index == 2 {
            Image("Editorial1984").resizable().scaledToFit()
        } else if index == 7 {
            Image("EditorialPride").resizable().scaledToFit()
        } else {
            BookCoverArtworkView(book: books[index])
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    let onSearch: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            SearchFieldView(text: $searchText, onSearch: onSearch)
                .padding(.horizontal, 20)
                .padding(.top, 24)
            Spacer()
        }
        .background(Color("Canvas").ignoresSafeArea())
    }
}

struct SearchFieldView: View {
    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("Muted"))
                .accessibilityHidden(true)

            TextField("Buscar libros", text: $text)
                .foregroundStyle(Color("Ink"))
                .tint(Color("Accent"))
                .submitLabel(.search)
                .accessibilityLabel("Buscar libros")
                .onSubmit {
                    onSearch()
                }
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 52)
        .background(Color("SearchSurface"), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("Border"), lineWidth: 1))
    }
}

struct BookRowView: View {
    let book: Book
    let destination: Int

    var body: some View {
        NavigationLink(value: destination) {
            HStack(spacing: 16) {
                SmallBookCoverView(book: book)
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.headline)
                        .foregroundStyle(Color("Ink"))
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundStyle(Color("Muted"))
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("Muted"))
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

// Imágenes ilustrativas originales para tres libros locales; no son portadas oficiales.
struct BookCoverArtworkView: View {
    let book: Book

    private var imageName: String? {
        switch book.title {
        case "Harry Potter y la piedra filosofal": return "EditorialHarry"
        case "Orgullo y prejuicio": return "EditorialPride"
        case "1984": return "Editorial1984"
        default: return nil
        }
    }

    var body: some View {
        Group {
            if book.hasCover, let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("NavSurface"))
                    .overlay {
                        VStack(spacing: 7) {
                            Image(systemName: book.hasCover ? "book.closed" : "book")
                                .font(.title2)
                            Text(book.hasCover ? "Portada pendiente" : "Sin portada")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(Color("Muted"))
                        .padding(6)
                    }
            }
        }
        .accessibilityLabel(book.hasCover && imageName != nil ? "Ilustración del libro \(book.title)" : (book.hasCover ? "Portada pendiente" : "Sin portada"))
    }
}

struct SmallBookCoverView: View {
    let book: Book

    var body: some View {
        BookCoverArtworkView(book: book)
            .frame(width: 84, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct BottomNavigationView: View {
    let homeActive: Bool
    let onHome: () -> Void
    let onMyBooks: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            tabButton(title: "Inicio", symbol: homeActive ? "house.fill" : "house", selected: homeActive, action: onHome)
            tabButton(title: "Mis favoritos", symbol: homeActive ? "bookmark" : "bookmark.fill", selected: !homeActive, action: onMyBooks)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color("NavSurface"), in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color("Border"), lineWidth: 0.7))
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
    }

    private func tabButton(title: String, symbol: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: symbol)
                    .font(title == "Mis favoritos" ? .system(size: 23, weight: .semibold) : .title3)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.caption.weight(selected ? .semibold : .regular))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(selected ? Color("Accent") : Color("Muted"))
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }
}
