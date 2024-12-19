struct Ship: Decodable {
    let id: String
    let name: String
    let image: String?
    let type: String
    let year: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case type
        case year = "year_built"
    }
}
