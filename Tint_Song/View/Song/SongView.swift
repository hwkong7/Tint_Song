import SwiftUI

struct SongView: View {
    @State private var viewModel = SongViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            SongListView(viewModel: viewModel)
                .navigationDestination(for: Song.self) { song in
                    SongDetailView(song: song)
                }
                .navigationTitle("노래")
                .task { await viewModel.loadSongs() }
                .refreshable { await viewModel.loadSongs() }
                .toolbar {
                    Button {
                        showingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    SongAddView(viewModel: viewModel)
                }
        }
    }
}
