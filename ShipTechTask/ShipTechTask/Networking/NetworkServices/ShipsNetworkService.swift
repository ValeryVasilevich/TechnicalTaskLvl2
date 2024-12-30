struct ShipsNetworkService {
    private let shipsRequestFactory = ShipsRequestFactory()

    func fetchShips() async throws -> [Ship] {
        let request = try shipsRequestFactory.getShips()
        return try await NetworkManager.shared.performRequest(request, decodeTo: [Ship].self)
    }

    func fetchShip(by id: String) async throws -> Ship {
        let request = try shipsRequestFactory.getShip(by: id)
        return try await NetworkManager.shared.performRequest(request, decodeTo: Ship.self)
    }
}
