import Foundation

struct Tint: Identifiable, Codable, Hashable {
    let id: UUID
    let productName: String
    let brand: String
    let colorFamily: String?
    let rating: Int
    let description: String?
}
