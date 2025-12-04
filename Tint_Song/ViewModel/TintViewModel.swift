import SwiftUI

@MainActor
@Observable
final class TintViewModel {
    private let repository: TintRepository
    
    init(repository: TintRepository = SupabaseTintRepository()) {
        self.repository = repository
    }
    
    private var _tints: [Tint] = []
    var tints: [Tint] { _tints }
    
    var path = NavigationPath()
    
    func loadTints() async {
        _tints = try! await repository.fetchTints()
    }
    
    func addTint(_ tint: Tint) async {
        do {
            try await repository.saveTint(tint)
            _tints.append(tint)
        } catch {
            print("error: \(error)")
        }
    }

    func deleteTint(_ tint: Tint) async {
        do {
            try await repository.deleteTint(tint.id.uuidString)
            _tints.removeAll { $0.id == tint.id }
        } catch {
            print("error: \(error)")
        }
    }
}
