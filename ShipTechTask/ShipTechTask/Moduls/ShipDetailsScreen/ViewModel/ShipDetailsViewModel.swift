import Combine
import Foundation

fileprivate enum Constants {
    static let errorMessage = "Failed to fetch details of ship."
    static let namePrefix = "Ship name: "
    static let typePrefix = "Ship type: "
    static let builtYearPrefix = "Built year: "
    static let weightPrefix = "Weight:"
    static let weightSuffix = "kg"
    static let homePortPrefix = "Home port: "
}

final class ShipDetailsViewModel {

    // MARK: - Properties

    @Published var ship: Ship? {
        didSet {
            updateFormattedDetails()
        }
    }

    @Published var formattedShipDetails: ShipDetailsFormatted?
    @Published var isOfflineMode: Bool = false
    @Published var errorMessage: String?

    private let dataProvider: ShipDataProvider

    // MARK: - Initializer

    init(dataProvider: ShipDataProvider, shipId: String) {
        self.dataProvider = dataProvider
        loadInitialData(by: shipId)
    }

    private func loadInitialData(by id: String) {
        Task {
            await fetchShip(by: id)
        }
    }

    // MARK: - Fetch Ship

    private func fetchShip(by id: String) async {
        do {
            ship = try await dataProvider.fetchShip(by: id)
        } catch {
            errorMessage = Constants.errorMessage
        }
    }

    private func updateFormattedDetails() {
        guard let ship else {
            formattedShipDetails = nil
            return
        }

        formattedShipDetails = ShipDetailsFormatted(
            name: "\(Constants.namePrefix)\(ship.name)",
            type: "\(Constants.typePrefix)\(ship.type)",
            image: ship.image ?? "",
            builtYear: "\(Constants.builtYearPrefix)\(ship.builtYear)",
            weight: "\(Constants.weightPrefix) \(ship.weight ?? 0) \(Constants.weightSuffix)",
            homePort: "\(Constants.homePortPrefix)\(ship.homePort ?? "")",
            roles: ship.roles ?? [""]
        )
    }
}
