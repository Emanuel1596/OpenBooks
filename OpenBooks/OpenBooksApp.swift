import Foundation
import SwiftUI
import SwiftData

@main
@MainActor
struct OpenBooksApp: App {
    private let container: ModelContainer
    private let searchService: any BookSearchService
    private let usesMockSearch: Bool
    @State private var booksState: BooksState

    init() {
        do {
            let modelContainer = try ModelContainer(for: SavedBook.self)
            container = modelContainer
            let launchArguments = ProcessInfo.processInfo.arguments
            let useMockSearch = launchArguments.contains("useMockSearch")
                || launchArguments.contains("-useMockSearch")
                || launchArguments.contains("--useMockSearch")
                || UserDefaults.standard.string(forKey: "useMockSearch") == "true"
            usesMockSearch = useMockSearch
            _booksState = State(initialValue: BooksState(
                store: SavedBooksRepository(context: modelContainer.mainContext),
                books: useMockSearch ? mockBooks : []
            ))
            searchService = useMockSearch
                ? MockBookSearchService() : OpenLibraryBookSearchService()
        } catch {
            fatalError("No se pudo iniciar el almacenamiento: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(booksState: booksState, searchService: searchService,
                        usesMockSearch: usesMockSearch)
        }
        .modelContainer(container)
    }
}
