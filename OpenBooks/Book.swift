import SwiftUI

struct Book {
    let title: String
    let author: String
    let year: String?
    let hasCover: Bool
    var isSaved: Bool
}



enum SearchViewState {
    case loading
    case content
    case noResults
    case error
}
