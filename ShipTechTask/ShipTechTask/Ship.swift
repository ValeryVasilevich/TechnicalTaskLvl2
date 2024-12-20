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

    init(entity: ShipEntity) {
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.image = entity.image
        self.type = entity.type ?? ""
        self.year = entity.year == 0 ? nil : Int(entity.year)
    }
}
