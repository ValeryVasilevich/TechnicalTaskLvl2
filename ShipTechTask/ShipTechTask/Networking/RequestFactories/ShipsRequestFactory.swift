import Foundation

struct ShipsRequestFactory: NetworkRequestFactory {
    var baseURL: URL {
        return URL(string: AppConstants.domain)!
    }

    func getShips() throws -> URLRequest {
        try makeRequest(path: "/v4/ships")
    }

    func getShip(by id: String) throws -> URLRequest {
        try makeRequest(path: "/v4/ships/\(id)")
    }
}
