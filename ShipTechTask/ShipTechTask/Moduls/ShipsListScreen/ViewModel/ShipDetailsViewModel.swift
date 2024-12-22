import Combine
import Foundation

final class ShipDetailsViewModel {

    // MARK: - Properties

    @Published var ship: Ship?
    @Published var isOfflineMode: Bool = false
    @Published var errorMessage: String?

    private let dataProvider: DataProvider
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initializer

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    // MARK: - Fetch Ship

    func fetchShips(by id: String) async {
        do {
            ship = try await dataProvider.fetchShip(by: id)
        } catch {
            errorMessage = "Failed to fetch details of ship."
        }
    }
}
