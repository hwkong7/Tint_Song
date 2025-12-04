import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TintView()
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Tint")
                }
            
            SongView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Songs")
                }
        }
    }
}


#Preview {
    ContentView()
}
