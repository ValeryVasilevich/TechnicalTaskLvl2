fileprivate enum Constants {
    static let namePrefix = "Ship name: "
    static let typePrefix = "Ship type: "
    static let builtYearPrefix = "Built year: "
    static let weightPrefix = "Weight:"
    static let weightSuffix = "kg"
    static let homePortPrefix = "Home port: "
}

struct ShipDetailsFormatted {
    let name: String
    let type: String
    let image: String
    let builtYear: String
    let weight: String
    let homePort: String
    let roles: [String]

    init(from ship: Ship) {
        self.name = "\(Constants.namePrefix)\(ship.name)"
        self.type = "\(Constants.typePrefix)\(ship.type)"
        self.image = ship.image ?? ""
        self.builtYear = "\(Constants.builtYearPrefix)\(ship.builtYear)"
        self.weight = "\(Constants.weightPrefix) \(ship.weight ?? 0) \(Constants.weightSuffix)"
        self.homePort = "\(Constants.homePortPrefix)\(ship.homePort ?? "")"
        self.roles = ship.roles ?? [""]
    }
}
