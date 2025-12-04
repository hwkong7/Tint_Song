import SwiftUI

struct SongDetailView: View {
    let song: Song

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(song.singer)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(song.rating))
                        .font(.title)
                        .foregroundColor(.yellow)
                }
                .padding(.bottom, 10)

                Text(song.lyrics ?? "(가사 없음)")
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.large)
    }
}
