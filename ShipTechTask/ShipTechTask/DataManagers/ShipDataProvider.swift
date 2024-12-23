import Combine

struct ShipDataProvider {
    private let networkService: ShipsNetworkService
    private let dataStore: LocalStorageManager
    private let connectionChecker: ConnectionChecker

    private var connectionStatusSubject = CurrentValueSubject<Bool, Never>(true)

    var connectionStatusPublisher: AnyPublisher<Bool, Never> {
        return connectionStatusSubject.eraseToAnyPublisher()
    }

    init(
        networkService: ShipsNetworkService,
        dataStore: LocalStorageManager,
        connectionChecker: ConnectionChecker
    ) {
        self.networkService = networkService
        self.dataStore = dataStore
        self.connectionChecker = connectionChecker
    }

    private func updateConnectionStatus() {
        connectionStatusSubject.send(connectionChecker.isConnected)
    }

    func fetchShips() async throws -> [Ship] {
        updateConnectionStatus()

        if connectionChecker.isConnected {
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
        updateConnectionStatus()
        
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
        try await dataStore.deleteShip(by: id)
    }
 }
