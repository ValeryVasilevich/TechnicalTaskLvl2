final class DataCoordinator {
    private let networkService: ShipsNetworkService
    private let dataStore: LocalStorageManager
    private let connectionChecker: ConnectionChecker
    private let authProvider: AuthenticationProvider

    init(
        networkService: ShipsNetworkService,
        dataStore: LocalStorageManager,
        connectionChecker: ConnectionChecker,
        authProvider: AuthenticationProvider
    ) {
        self.networkService = networkService
        self.dataStore = dataStore
        self.connectionChecker = connectionChecker
        self.authProvider = authProvider
    }

    func fetchShips() async throws -> [Ship] {
        guard authProvider.isUserLoggedIn else {
            throw NetworkError.unauthorized
        }

        if connectionChecker.isConnected {
            let apiShips = try await networkService.fetchShips()
            try dataStore.saveShips(apiShips)
            return apiShips
        } else {
            return try dataStore.fetchShips()
        }
    }

    func fetchShip(by id: String) async throws -> Ship {
        guard authProvider.isUserLoggedIn else {
            throw NetworkError.unauthorized
        }

        if connectionChecker.isConnected {
            let apiShip = try await networkService.fetchShip(by: id)
            try dataStore.updateShip(apiShip)
            return apiShip
        } else {
            guard let localShip = try dataStore.fetchShip(by: id) else {
                throw NetworkError.dataNotFound
            }
            return localShip
        }
    }
}
