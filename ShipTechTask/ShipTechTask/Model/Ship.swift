import Foundation

struct Ship: Decodable {
    let id: String
    let name: String
    let image: String?
    let type: String
    let roles: [String]?
    let weight: Int?
    let dateBuild: Date?
    let homePort: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case type
        case roles
        case weight = "mass_kg"
        case dateBuild = "year_built"
        case homePort = "home_port"
    }

    init(entity: ShipEntity) {
        self.id = entity.id
        self.name = entity.name
        self.image = entity.image
        self.type = entity.type
        self.dateBuild = entity.dateBuild
        // TODO: - add properties to ShipEntity model
        self.roles = nil
        self.weight = nil
        self.homePort = nil
    }

    var builtYear: String {
        guard let dateBuild = dateBuild else { return "-" }
        return DateFormatterService.shared.formatYear(from: dateBuild)
    }
}
