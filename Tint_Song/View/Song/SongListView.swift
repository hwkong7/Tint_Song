import SwiftUI

struct SongListView: View {
    let viewModel: SongViewModel
    
    func deleteSong(offsets: IndexSet) {
        Task {
            for index in offsets {
                let song = viewModel.songs[index]
                await viewModel.deleteSong(song)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(viewModel.songs) { song in
                NavigationLink(value: song) {
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.headline)
                        Text(song.singer)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete(perform: deleteSong)
        }
    }
}
