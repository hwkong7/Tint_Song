import SwiftUI

struct TintView: View {
    @State private var viewModel = TintViewModel()   // ✅ @State 로 변경
    @State private var showingAddSheet = false
    let viewModel: TintViewModel

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            TintListView(viewModel: viewModel)
                .navigationDestination(for: Tint.self) { tint in
                    TintDetailView(tint: tint)
                }
                .navigationTitle("틴트")
                .task {
                    await viewModel.loadTints()
                }
                .refreshable {
                    await viewModel.loadTints()
                }
                .toolbar {
                    Button {
                        showingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    TintAddView(viewModel: viewModel)
                }
        }
    }
}
