import Foundation

struct ConnectionDetails: Codable {
    let serverUrl: String
    let roomName: String
    let participantName: String
    let participantToken: String
}

class TokenService {
    private let sandboxId: String = {
        guard let sandboxId = Bundle.main.object(forInfoDictionaryKey: "LKSandboxTokenServerId") as? String else {
            fatalError("LKSandboxTokenServerId not found. Did you add it to Secrets.xcconfig?")
        }
        return sandboxId
    }()

    private let baseUrl = "https://cloud-api.livekit.io/api/sandbox/connection-details"

    func fetchConnectionDetails(roomName: String, participantName: String) async throws -> ConnectionDetails {
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "roomName", value: roomName),
            URLQueryItem(name: "participantName", value: participantName),
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue(sandboxId, forHTTPHeaderField: "X-Sandbox-ID")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(ConnectionDetails.self, from: data)
    }
}
