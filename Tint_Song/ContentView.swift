//
//  ContentView.swift
//  Tint_Song
//
//  Created by student on 12/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 1️⃣ Song 자리에 Tint 넣기
            TintView()
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Tint")
                }

            // 2️⃣ Singer 자리에 Song 넣기
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
