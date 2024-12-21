import Combine
import Foundation

final class ShipListViewModel {

    // MARK: - Properties

    @Published var ships: [Ship] = []
    @Published var isOfflineMode: Bool = false
    @Published var errorMessage: String?

    private let dataProvider: DataProvider
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initializer

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    // MARK: - Fetch Ships

    func fetchShips() {
        Task {
            do {
                let fetchedShips = try await dataProvider.fetchShips(refreshFromAPI: true)
                DispatchQueue.main.async {
                    self.ships = fetchedShips.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch ships."
                }
            }
        }
    }

    // MARK: - Delete Ship

    func deleteShip(by id: String) {
        Task {
            do {
                try await dataProvider.deleteShip(by: id)
                DispatchQueue.main.async {
                    self.ships.removeAll { $0.id == id }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to delete ship."
                }
            }
        }
    }
}
