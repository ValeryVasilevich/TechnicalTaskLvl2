protocol LocalStorageManager {
    func fetchShips() throws -> [Ship]
    func fetchShip(by id: String) throws -> Ship?
    func saveShips(_ ships: [Ship]) throws
    func updateShip(_ ship: Ship) throws
}

final class ShipsStorageManager: LocalStorageManager {
    static let shared = ShipsStorageManager()

    func fetchShips() throws -> [Ship] {
        []
    }

    func fetchShip(by id: String) throws -> Ship? {
        nil
    }

    func saveShips(_ ships: [Ship]) throws {

    }

    func updateShip(_ ship: Ship) throws {

    }
}
