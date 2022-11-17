//
//  GameDetail.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI
import CoreData

struct GameDetail: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var game: Game
    
    @State private var showDeleteAlert = false
    @State private var showResetAlert = false
    @State private var showAddPlayerAlert = false
    @State private var playerToAdd = ""
    @State private var isHistoryExpanded: Bool = false
    @State private var showHistorySheet = false
    @State private var showEditSheet = false
    
    private var gameHistory: [GameRecord]
    private var gamePlayers: [Player]
    
    init(game: Game) {
        self.game = game
        
        let playerRequest: NSFetchRequest<Player> = Player.fetchRequest()
        playerRequest.predicate = NSPredicate(format: "playerGame == %@", game)
        playerRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Player.name, ascending: true)]
        gamePlayers = try! PersistenceController.shared.container.viewContext.fetch(playerRequest)
        
        let request: NSFetchRequest<GameRecord> = GameRecord.fetchRequest()
        request.predicate = NSPredicate(format: "recordGame == %@", game)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameRecord.timestamp, ascending: false)]
        gameHistory = try! PersistenceController.shared.container.viewContext.fetch(request)
    }
    
    var body: some View {
        ScrollView {
            ForEach(gamePlayers) { player in
                PlayerRow(player: player)
            }
            .padding(.horizontal, 15)
            
            Divider()
                .padding(.vertical, 20)
            DisclosureGroup("history", isExpanded: $isHistoryExpanded.animation()) {
                VStack {
                    if gameHistory.count == 0 {
                        Text("noRecords")
                    }
                    ForEach(gameHistory.prefix(5)) { record in
                        HStack {
                            Text("\(record.result)")
                                .fontWeight(.bold)
                                .frame(width: 50)
                                .multilineTextAlignment(.leading)
                            Divider()
                            Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                            Spacer()
                            Text(record.recordPlayer?.name ?? "")
                                .multilineTextAlignment(.trailing)
                            Divider()
                            Text(record.wrappedTimestamp.dateToFormattedDatetime())
                        }
                    }
                    
                    if gameHistory.count > 5 {
                        Button(action: {
                            showHistorySheet.toggle()
                        }) {
                            Text("allRecords")
                                .foregroundColor(Color.blue)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            
            HStack {
                Text("")
                    .alert(isPresented: $showResetAlert) {
                        Alert(
                            title: Text("youSure"),
                            message: Text("resetGame \(game.wrappedName)"),
                            primaryButton: .cancel(
                                Text("cancel")
                            ),
                            secondaryButton: .destructive(
                                Text("reset"),
                                action: {
                                    GameManager.shared.resetGame(game: game)
                                }
                            )
                        )
                    }
                Text("")
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("youSure"),
                            message: Text("deleteGame \(game.wrappedName)"),
                            primaryButton: .cancel(
                                Text("cancel")
                            ),
                            secondaryButton: .destructive(
                                Text("delete"),
                                action: {
                                    viewContext.delete(game)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        )
                    }
                Text("")
                    .alert("addPlayer", isPresented: $showAddPlayerAlert, actions: {
                        TextField("playerName", text: $playerToAdd)
                        
                        Button("add".localized(), action: {
                            GameManager.shared.addPlayerToGame(game: game, playerName: playerToAdd)
                            playerToAdd = ""
                        })
                        Button("cancel", role: .cancel, action: {})})
                
            }
            .sheet(isPresented: $showEditSheet) {
                GameAddEdit(gameToEdit: game)
            }
            .sheet(isPresented: $showHistorySheet) {
                GameHistory(gameName: game.wrappedName, gameRecords: gameHistory)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: game.icon ?? "")
                            .font(.system(size: 25))
                            .foregroundColor(Color(game.wrappedColor))
                        Text("\(game.name ?? "")")
                            .font(.system(size: 25))
                            .fontWeight(Font.Weight.semibold)
                            .foregroundColor(Color(game.wrappedColor))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        GameManager.shared.toggleFavourite(game: game)
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


struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let previewPlayer = Player(context: PersistenceController.shared.container.viewContext)
        previewPlayer.id = UUID()
        previewPlayer.name = "Bohumil"
        previewPlayer.score = 10
        previewPlayer.createdAt = Date()
        previewPlayer.modifiedAt = Date()
        
        let previewGame = Game(context: PersistenceController.shared.container.viewContext)
        previewGame.id = UUID()
        previewGame.name = "NHL"
        previewGame.color = "picker_orange"
        previewGame.icon = "heart.circle.fill"
        previewGame.createdAt = Date()
        
        return NavigationStack {
            GameDetail(game: previewGame).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
