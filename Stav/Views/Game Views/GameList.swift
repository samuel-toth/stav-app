//
//  GameList.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI
import SwiftData

struct GameList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.name) var allGames: [Game]
        
    @State private var isSheetPresented: Bool = false
    @State private var showFavourite: Bool = false
    
    var body: some View {
        NavigationStack {
            if allGames.isEmpty {
                Image("AppIconNoBg")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.1)
            }
            List {
                ForEach(allGames) { game in
                    NavigationLink(value: game) {
                        GameRow(game: game)
                            .frame(height: 50)
                    }
                }
                .onDelete(perform: deleteGame)
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground).opacity(0.8))
            }
            .navigationDestination(for: Game.self, destination: { game in
                GameDetail(game: game)
            })
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isSheetPresented.toggle()
                    }) {
                        Label("add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Section {
                            Button(action: {
                                showFavourite.toggle()
                                // TODO: Show favourite games
                            }) {
                                Label(showFavourite ? "showAllGames" : "showFavourites", systemImage: showFavourite ? "heart.slash" : "heart")
                            }
                        }
                        
                        // TODO: Implement import export
                        Section(header: Text("settings")) {
                            Button(action: {}) {
                                Label("importGames", systemImage: "arrow.down.doc")
                            }
                            Button(action: {}) {
                                Label("exportGames", systemImage: "arrow.up.doc")
                            }
                        }
                    } label: {Label("add", systemImage: "ellipsis")}
                }
            }
            .sheet(isPresented: $isSheetPresented, content: {
                GameAddEdit()
            })
            .navigationTitle("games")
        }
    }
    
    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(allGames[index])
                try? modelContext.save()
            }
        }
    }
}

#Preview {
    GameList()
}
