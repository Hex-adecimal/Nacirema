//
//  ModalView.swift
//  Nacirema
//
//  Created by Luigi Penza on 18/11/23.
//

import SwiftUI
import SwiftData

struct ModalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var songs: [Song]
    @State private var isFullScreen: Bool = false //TODO: ...
    
    let columns = [GridItem(.adaptive(minimum: 170)), GridItem(.adaptive(minimum: 170))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(songs) { song in
                        ZStack {
                            Image(song.image)
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundStyle(.indigo)
                                .padding(.top, 80)
                            
                            VStack {
                                Text(song.name)
                                Text(song.artist)
                            }
                        }
                        .frame(width: 170, height: 170)
                    }
                }
            }
            
            Button("Insert") {
                modelContext.insert(Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea"))
                modelContext.insert(Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea"))
                modelContext.insert(Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea"))
                modelContext.insert(Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea"))
                modelContext.insert(Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea"))
                modelContext.insert(Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea"))
            }
        }
        .navigationTitle("My music")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "gear")
            }
        }
        .toolbar(isFullScreen ? .visible : .hidden, for: .navigationBar)
    }
}
