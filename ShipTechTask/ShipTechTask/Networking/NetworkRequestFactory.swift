import Foundation

protocol NetworkRequestFactory {
    var baseURL: URL { get }
    func makeRequest(path: String) throws -> URLRequest
}

extension NetworkRequestFactory {
    func makeRequest(path: String) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw NetworkError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }
}
