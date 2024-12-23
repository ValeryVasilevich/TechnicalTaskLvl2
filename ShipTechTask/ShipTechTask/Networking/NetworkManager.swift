import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession = .shared

    func performRequest<T: Decodable>(_ request: URLRequest, decodeTo type: T.Type) async throws -> T {
        let (data, response) = try await session.data(for: request)
        try processResponse(response)

        return try decodeData(data: data, type: T.self)
    }

    private func decodeData<T: Decodable>(data: Data, type: T.Type) throws -> T {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch let decodingError {
            throw NetworkError.decodingFailed(decodingError)
        }
    }

    private func processResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        case 404:
            throw NetworkError.notFound
        case 500:
            throw NetworkError.internalServerError
        default:
            throw NetworkError.unknownError(statusCode: httpResponse.statusCode)
        }
    }
}
