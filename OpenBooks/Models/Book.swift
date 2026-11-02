struct Book {
    let title: String
    let author: String
    let year: String?
    let hasCover: Bool
    var isSaved: Bool
    let synopsis: String?
    let genre: String?
    let originalLanguage: String?
    let originalTitle: String?
    let themes: [String]

    init(title: String, author: String, year: String?, hasCover: Bool,
         isSaved: Bool, synopsis: String? = nil, genre: String? = nil,
         originalLanguage: String? = nil, originalTitle: String? = nil,
         themes: [String] = []) {
        self.title = title
        self.author = author
        self.year = year
        self.hasCover = hasCover
        self.isSaved = isSaved
        self.synopsis = synopsis
        self.genre = genre
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.themes = themes
    }
}
