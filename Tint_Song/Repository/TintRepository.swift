protocol TintRepository: Sendable {
    func fetchTints() async throws -> [Tint]
    func saveTint(_ tint: Tint) async throws
    func deleteTint(_ id: String) async throws
}
