struct MockBookSearchService: BookSearchService {
    func searchBooks(query: String) async throws -> [Book] {
        switch query {
        case "Error de prueba":
            throw BookSearchError.connectivity("Error simulado")
        case "Harry Potter":
            return Array(mockBooks[3...6])
        case "Orgullo y prejuicio":
            return Array(mockBooks[7...9])
        default:
            return []
        }
    }
}
