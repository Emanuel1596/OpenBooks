import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let year: Int
}

struct ContentView: View {
    @State private var searchText = ""

    private let books = [
        Book(
            title: "Cien años de soledad",
            author: "Gabriel García Márquez",
            year: 1967
        ),
        Book(
            title: "El principito",
            author: "Antoine de Saint-Exupéry",
            year: 1943
        ),
        Book(
            title: "1984",
            author: "George Orwell",
            year: 1949
        )
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("OpenBooks")
                            .font(.largeTitle)
                            .bold()

                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                                .foregroundStyle(.secondary)

                            TextField(
                                "Buscar libros",
                                text: $searchText
                            )
                        }
                        .padding(.horizontal, 16)
                        .frame(minHeight: 52)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    Color.secondary.opacity(0.7),
                                    lineWidth: 1
                                )
                        }

                        Text("Libros")
                            .font(.title2)
                            .bold()

                        VStack(spacing: 0) {
                            ForEach(books) { book in
                                NavigationLink {
                                    BookDetailView(book: book)
                                } label: {
                                    BookRow(book: book)
                                }
                                .buttonStyle(.plain)

                                Divider()
                                    .padding(.leading, 100)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }

                Divider()

                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.title2)

                        Text("Inicio")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .font(.title2)

                        Text("Mis libros")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 10)
            }
        }
    }
}

struct BookRow: View {
    let book: Book

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.08))

                RoundedRectangle(cornerRadius: 3)
                    .stroke(
                        Color.secondary.opacity(0.7),
                        lineWidth: 1
                    )

                Image(systemName: "book.closed")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 84, height: 108)

            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.headline)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.headline)
        }
        .padding(.vertical, 16)
    }
}
