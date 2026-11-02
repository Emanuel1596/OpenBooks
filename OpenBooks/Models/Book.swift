struct Book {
    let title: String
    let author: String
    let year: String?
    let hasCover: Bool
    var isSaved: Bool
    let synopsis: String?

    init(title: String, author: String, year: String?, hasCover: Bool,
         isSaved: Bool, synopsis: String? = nil) {
        self.title = title
        self.author = author
        self.year = year
        self.hasCover = hasCover
        self.isSaved = isSaved
        self.synopsis = synopsis
    }
}
