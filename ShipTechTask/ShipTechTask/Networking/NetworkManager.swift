import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession = .shared
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        try processResponse(response)

        return try decodeData(data)
    }

    private func decodeData<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError.decodingFailed(error)
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
