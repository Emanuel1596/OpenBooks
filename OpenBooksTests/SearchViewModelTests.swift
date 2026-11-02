import XCTest
@testable import OpenBooks

// Pruebas deterministas: no usan red ni dependen del orden de una API.
@MainActor
final class SearchViewModelTests: XCTestCase {
    func testHarryPotterReturnsFourResults() {
        // Arrange
        let viewModel = SearchViewModel()
        viewModel.searchText = "Harry Potter"
        // Act
        viewModel.searchBooks()
        // Assert
        XCTAssertEqual(viewModel.resultIndices, [3, 4, 5, 6])
        XCTAssertEqual(viewModel.state, .content)
    }

    func testPrideAndPrejudiceReturnsThreeResults() {
        let viewModel = SearchViewModel()
        viewModel.searchText = "Orgullo y prejuicio"
        viewModel.searchBooks()
        XCTAssertEqual(viewModel.resultIndices, [7, 8, 9])
        XCTAssertEqual(viewModel.state, .content)
    }

    func testEmptySearchReturnsNoResults() {
        let viewModel = SearchViewModel()
        viewModel.searchText = ""
        viewModel.searchBooks()
        XCTAssertTrue(viewModel.resultIndices.isEmpty)
        XCTAssertEqual(viewModel.state, .noResults)
    }

    func testUnknownSearchResetsPreviousResults() {
        let viewModel = SearchViewModel()
        viewModel.searchText = "Harry Potter"
        viewModel.searchBooks()
        viewModel.searchText = "Libro inexistente"
        viewModel.searchBooks()
        XCTAssertTrue(viewModel.resultIndices.isEmpty)
        XCTAssertEqual(viewModel.state, .noResults)
    }
}
