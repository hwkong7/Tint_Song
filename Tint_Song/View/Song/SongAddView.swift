import SwiftUI

struct SongAddView: View {
    let viewModel: SongViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var singer = ""
    @State var rating = 3
    @State var lyrics = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("노래 정보 *")) {
                    TextField("제목", text: $title)
                    TextField("가수", text: $singer)
                }
                
                Section(header: Text("선호도 *")) {
                    Picker("별점", selection: $rating) {
                        ForEach(1...5, id: \.self) { score in
                            Text("\(score)점").tag(score)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("가사")) {
                    TextEditor(text: $lyrics)
                        .frame(height: 150)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        Task {
                            await viewModel.addSong(
                                Song(id: UUID(), title: title, singer: singer, rating: rating, lyrics: lyrics)
                            )
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || singer.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
            }
        }
    }
}
