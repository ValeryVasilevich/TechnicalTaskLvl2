final class DataProvider {
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

    func fetchShips(refreshFromAPI: Bool = false) async throws -> [Ship] {
        guard authProvider.isUserLoggedIn else {
            throw NetworkError.unauthorized
        }

        if refreshFromAPI || connectionChecker.isConnected {
            let apiShips = try await networkService.fetchShips()
            let storedShips = try await dataStore.fetchShips()
            let newShips = apiShips.filter { apiShip in
                !storedShips.contains { storedShip in
                    storedShip.id == apiShip.id
                }
            }
            if !newShips.isEmpty {
                try await dataStore.saveShips(apiShips)
            }
            return apiShips
        } else {
            return try await dataStore.fetchShips()
        }
    }

    func fetchShip(by id: String) async throws -> Ship {
        guard authProvider.isUserLoggedIn else {
            throw NetworkError.unauthorized
        }

        if connectionChecker.isConnected {
            let apiShip = try await networkService.fetchShip(by: id)
            try await dataStore.saveShips([apiShip])
            return apiShip
        } else {
            guard let localShip = try await dataStore.fetchShip(by: id) else {
                throw NetworkError.dataNotFound
            }
            return localShip
        }
    }

    func deleteShip(by id: String) async throws {
        guard authProvider.isUserLoggedIn else {
            throw NetworkError.unauthorized
        }

        try await dataStore.deleteShip(by: id)
    }
 }
