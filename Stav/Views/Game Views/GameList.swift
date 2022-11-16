//
//  GameList.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct GameList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Game.name, ascending: true)])
    private var games: FetchedResults<Game>
    
    @State private var isSheetPresented: Bool = false
    @State private var showFavourite: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(games) { game in
                        NavigationLink(value: game) {
                            GameRow(game: game)
                                .frame(height: 50)
                        }
                    }
                    .onDelete(perform: deleteGame)
                }
                .navigationDestination(for: Game.self, destination: { game in
                    GameDetail(game: game)
                        .environment(\.managedObjectContext, viewContext)
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
                                    games.nsPredicate = showFavourite ?  NSPredicate(format: "isFavourite == %@", NSNumber(value: showFavourite)) : NSPredicate(format: "isFavourite == YES OR isFavourite == NO")
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
                    GameAdd()
                })
                .navigationTitle("games")
            }
        }
    }
    
    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            offsets.map { games[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GameList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
