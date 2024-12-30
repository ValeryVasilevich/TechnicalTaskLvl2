import Foundation

struct ShipsRequestFactory: NetworkRequestFactory {
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func getShips() throws -> URLRequest {
        try makeRequest(path: "/v4/ships")
    }

    func getShip(by id: String) throws -> URLRequest {
        try makeRequest(path: "/v4/ships/\(id)")
    }
}
