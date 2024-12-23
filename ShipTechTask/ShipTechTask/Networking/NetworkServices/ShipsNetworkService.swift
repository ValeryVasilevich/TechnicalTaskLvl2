struct ShipsNetworkService {
    private let shipsRequest = ShipsRequestFactory()

    func fetchShips() async throws -> [Ship] {
        let request = try shipsRequest.getShips()
        return try await NetworkManager.shared.performRequest(request, decodeTo: [Ship].self)
    }

    func fetchShip(by id: String) async throws -> Ship {
        let request = try shipsRequest.getShip(by: id)
        return try await NetworkManager.shared.performRequest(request, decodeTo: Ship.self)
    }
}
