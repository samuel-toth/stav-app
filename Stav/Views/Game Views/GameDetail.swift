//
//  GameDetail.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI
import SwiftData

struct GameDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Observable var game: Game
    
    @State private var showDeleteAlert = false
    @State private var showResetAlert = false
    @State private var showAddPlayerAlert = false
    @State private var playerToAdd = ""
    @State private var isHistoryExpanded: Bool = false
    @State private var showHistorySheet = false
    @State private var showEditSheet = false
    
    var body: some View {
        ScrollView {
            ForEach(game.players) { player in
                PlayerRow(player: player)
            }
            .padding(.horizontal, 15)
            
            Divider()
                .padding(.vertical, 20)
//            DisclosureGroup("history", isExpanded: $isHistoryExpanded.animation()) {
//                VStack {
//                    // TODO: now records for players in game detail
////                    if game.players. {
////                        Text("noRecords")
////                    }
//                    ForEach(gameHistory.prefix(5)) { record in
//                        HStack {
//                            Text("\(record.result)")
//                                .fontWeight(.bold)
//                                .frame(width: 50)
//                                .multilineTextAlignment(.leading)
//                            Divider()
//                            Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
//                            Spacer()
//                            Text(record.player?.name ?? "")
//                                .multilineTextAlignment(.trailing)
//                            Divider()
//                            Text(record.wrappedTimestamp.dateToFormattedDatetime())
//                        }
//                    }
                    
//                    if gameHistory.count > 5 {
//                        Button(action: {
//                            showHistorySheet.toggle()
//                        }) {
//                            Text("allRecords")
//                                .foregroundColor(Color.blue)
//                        }
//                    }
//                }
//                .padding(.top, 10)
//            }
//            .padding(.horizontal, 20)
            
            HStack {
                Text("")
                    .alert(isPresented: $showResetAlert) {
                        Alert(
                            title: Text("youSure"),
                            message: Text("resetGame \(game.name)"),
                            primaryButton: .cancel(
                                Text("cancel")
                            ),
                            secondaryButton: .destructive(
                                Text("reset"),
                                action: {
                                    //GameManager.shared.resetGame(game: game)
                                }
                            )
                        )
                    }
                Text("")
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("youSure"),
                            message: Text("deleteGame \(game.name)"),
                            primaryButton: .cancel(
                                Text("cancel")
                            ),
                            secondaryButton: .destructive(
                                Text("delete"),
                                action: {
                                    modelContext.delete(game)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        )
                    }
                Text("")
                    .alert("addPlayer", isPresented: $showAddPlayerAlert, actions: {
                        TextField("playerName", text: $playerToAdd)
                        
                        Button("add".localized(), action: {
                            //GameManager.shared.addPlayerToGame(game: game, playerName: playerToAdd)
                            playerToAdd = ""
                        })
                        Button("cancel", role: .cancel, action: {})})
            }
            .sheet(isPresented: $showEditSheet) {
                GameAddEdit(gameToEdit: game)
            }
//            TODO: game history sheet
//            .sheet(isPresented: $showHistorySheet) {
//                GameHistory(gameName: game.wrappedName, gameRecords: gameHistory)
//            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: game.icon )
                            .font(.system(size: 25))
                            .foregroundColor(Color(game.color))
                        Text(game.name)
                            .font(.system(size: 25))
                            .fontWeight(Font.Weight.semibold)
                            .foregroundColor(Color(game.color))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // GameManager.shared.toggleFavourite(game: game)
                    }) {
                        Image(systemName: game.isFavourite ? "heart.fill" : "heart")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Button(action: {
                                showAddPlayerAlert.toggle()
                            }) {
                                Label("addPlayer", systemImage: "person.crop.circle.badge.plus")
                            }
                        }
                        
                        Button(action: {
                            showEditSheet.toggle()
                        }) {
                            Label("edit", systemImage: "pencil")
                        }
                        Button(action: {
                            showResetAlert.toggle()
                        }) {
                            Label("reset", systemImage: "arrow.counterclockwise.circle")
                        }
                        Button(role: .destructive, action: {
                            showDeleteAlert.toggle()
                        }) {
                            Label("delete", systemImage: "trash")
                        }
                    }
                label: {
                    Label("more", systemImage: "ellipsis.circle")
                }
                }
            }
        }
    }
}


//struct GameDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        return NavigationStack {
//            GameDetail(game: previewGame)
//        }
//    }
//}
