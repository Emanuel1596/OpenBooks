import SwiftUI

struct BookDetailView: View {
    let book: Book

    @State private var isSaved = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.08))

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.secondary.opacity(0.5),
                            lineWidth: 1
                        )

                    Image(systemName: "book.closed")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                }
                .frame(width: 180, height: 240)

                VStack(spacing: 8) {
                    Text(book.title)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text(book.author)
                        .foregroundStyle(.secondary)

                    Text("Año: \(book.year)")
                        .foregroundStyle(.secondary)
                }

                Button {
                    isSaved.toggle()
                } label: {
                    Text(
                        isSaved
                        ? "Eliminar de Mis libros"
                        : "Guardar en Mis libros"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}
