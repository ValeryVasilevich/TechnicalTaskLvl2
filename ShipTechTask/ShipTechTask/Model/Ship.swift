import Foundation

struct Ship: Decodable {
    let id: String
    let name: String
    let image: String?
    let type: String
    let dateBuild: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case type
        case dateBuild = "year_built"
    }

    init(entity: ShipEntity) {
        self.id = entity.id
        self.name = entity.name
        self.image = entity.image
        self.type = entity.type
        self.dateBuild = entity.dateBuild
    }

    var builtYear: String {
        guard let dateBuild = dateBuild else { return "-" }
        return DateFormatterService.shared.formatYear(from: dateBuild)
    }
}
