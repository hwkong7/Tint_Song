import Foundation

struct SupabaseTintRepository: TintRepository {

    func fetchTints() async throws -> [Tint] {
        let url = URL(string: SongApiConfig.serverURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase   // ⭐ snake_case → camelCase 자동 변환

        return try decoder.decode([Tint].self, from: data)
    }

    func saveTint(_ tint: Tint) async throws {
        let url = URL(string: SongApiConfig.serverURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase       // ⭐ camelCase → snake_case 자동 변환
        request.httpBody = try encoder.encode(tint)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 || httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

    func deleteTint(_ id: String) async throws {
        let urlString = "\(SongApiConfig.projectURL)/rest/v1/cosmetics?id=eq.\(id)&apikey=\(SongApiConfig.apiKey)"
        let requestURL = URL(string: urlString)!

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
}
