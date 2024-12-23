import Combine
import Foundation

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

    private let dataProvider: DataProvider

    // MARK: - Initializer

    init(dataProvider: DataProvider, shipId: String) {
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
            errorMessage = "Failed to fetch details of ship."
        }
    }

    private func updateFormattedDetails() {
        guard let ship = ship else {
            formattedShipDetails = nil
            return
        }

        formattedShipDetails = ShipDetailsFormatted(
            name: "Ship name: \(ship.name)",
            type: "Ship type: \(ship.type)",
            builtYear: "Built year: \(ship.builtYear)",
            weight: "Weight: \(ship.weight ?? 0) kg",
            homePort: "Home port: \(ship.homePort ?? "N/A")",
            roles: ship.roles ?? ["N/A"]
        )
    }
}
