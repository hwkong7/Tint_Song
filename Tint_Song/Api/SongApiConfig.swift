// SongAPIConfig.swift

//struct SongApiConfig {
struct SongApiConfig {
    static let projectURL = "https://meonznlfvhfpipubcpoj.supabase.co"
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1lb256bmxmdmhmcGlwdWJjcG9qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4MTMxNzMsImV4cCI6MjA4MDM4OTE3M30.Vb7RVlBP1RPLbzuqMLiG6wZ08rI-pglBuYXObi-uUqY"
    static let serverURL = "\(projectURL)/rest/v1/songs?apikey=\(apiKey)"
    static let cosmeticsURL = "\(projectURL)/rest/v1/cosmetics?apikey=\(apiKey)" //틴트 추가
}
