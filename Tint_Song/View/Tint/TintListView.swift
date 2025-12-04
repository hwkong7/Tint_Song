import SwiftUI

struct TintListView: View {
    @State private var viewModel = TintViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                ForEach(viewModel.tints) { tint in
                    NavigationLink(value: tint) {
                        VStack(alignment: .leading) {
                            Text(tint.productName)
                                .font(.headline)
                            Text(tint.brand)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    Task {
                        for index in indexSet {
                            let tint = viewModel.tints[index]
                            await viewModel.deleteTint(tint)
                        }
                    }
                }
            }
            .navigationDestination(for: Tint.self) { tint in
                TintDetailView(tint: tint)
            }
            .navigationTitle("Tint 💄")
            .task {
                await viewModel.loadTints()
            }
            .refreshable {
                await viewModel.loadTints()
            }
            .toolbar {
                Button {
                    showingAddSheet = true
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
