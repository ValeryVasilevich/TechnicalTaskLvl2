import Foundation

struct ShipsNetworkService {
    let url: URL
    let shipsRequestFactory: ShipsRequestFactory

    init(baseURL: URL) {
        self.url = baseURL
        self.shipsRequestFactory = ShipsRequestFactory(baseURL: url)
    }

    func fetchShips() async throws -> [Ship] {
        let request = try shipsRequestFactory.getShips()
        return try await NetworkManager.shared.performRequest(request, decodeTo: [Ship].self)
    }

    func fetchShip(by id: String) async throws -> Ship {
        let request = try shipsRequestFactory.getShip(by: id)
        return try await NetworkManager.shared.performRequest(request, decodeTo: Ship.self)
    }
}
