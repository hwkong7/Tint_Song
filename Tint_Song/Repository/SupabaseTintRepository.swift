import Foundation

struct SupabaseTintRepository: TintRepository {

    // MARK: - GET (Read)
    func fetchTints() async throws -> [Tint] {
        // cosmetics 테이블 URL 사용
        let url = URL(string: SongApiConfig.cosmeticsURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")

        let (data, _) = try await URLSession.shared.data(for: request)

        // JSON snake_case → camelCase 자동 변환
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode([Tint].self, from: data)
    }

    // MARK: - POST (Create)
    func saveTint(_ tint: Tint) async throws {
        let url = URL(string: SongApiConfig.cosmeticsURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")

        // Swift camelCase → DB snake_case 자동 변환
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(tint)

        let (_, response) = try await URLSession.shared.data(for: request)

        // 201 Created 또는 200 OK
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 || httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

    // MARK: - DELETE
    func deleteTint(_ id: String) async throws {
        // DELETE는 filter 형식이 다름
        let urlString = "\(SongApiConfig.projectURL)/rest/v1/cosmetics?id=eq.\(id)&apikey=\(SongApiConfig.apiKey)"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
}
