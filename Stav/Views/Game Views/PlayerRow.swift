//
//  PlayerRow.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct PlayerRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var player: Player
    
    @State private var showPlayerHistory = false
    @State private var showRenamePlayer = false
    @State private var playerNewName = ""
    
    init(player: Player) {
        self.player = player
    }
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(Color(player.playerGame?.color ?? "AccentColor"))
            VStack(alignment: .leading) {
                Text(player.name ?? "")
                    .font(Font.system(.title3, design: .default))
                    .lineLimit(1)
                Text(player.modifiedAt?.localizedTimeDifference() ?? Date().localizedTimeDifference())
                    .font(Font.system(.caption, design: .default))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            Spacer()
            
            HStack {
                Button("+") {
                    updateValue(value: 1)
                }
                .font(.system(size: 44))
                .onTapGesture {
                    updateValue(value: 1)
                }
                
                Button("-") {
                    updateValue(value: -1)
                }
                .font(.system(size: 44))
                .padding(.horizontal, 10)
                .onTapGesture {
                    updateValue(value: -1)
                }
                
                Divider()
                
                Text("\(player.score)")
                    .valueDisplayStyle()
            }
        }
        .alert("renamePlayer \(player.wrappedName)", isPresented: $showRenamePlayer, actions: {
            TextField("newName", text: $playerNewName)
            
            Button("rename", action: {
                withAnimation {
                    GameManager.shared.renamePlayer(player: player, name: playerNewName)
                    playerNewName = ""
                }
            })
            Button("cancel", role: .cancel, action: {})})
        .padding()
        .frame(height: 70)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .sheet(isPresented: $showPlayerHistory) {
            PlayerHistory(gameRecords: player.playerRecords?.toArray() ?? [], playerName: player.wrappedName)
        }
        .contextMenu {
            Button {
                showRenamePlayer.toggle()
            } label: {
                Label("renamePlayer \(player.wrappedName)", systemImage: "person.text.rectangle")
            }
            
            Button {
                showPlayerHistory.toggle()
            } label: {
                Label("showHistory", systemImage: "arrow.up.doc")
            }
            
            Button {
                GameManager.shared.resetPlayer(player: player)
            } label: {
                Label("resetPlayer \(player.wrappedName)", systemImage: "arrow.counterclockwise.circle")
            }
        }
    }
    
    func updateValue(value: Int) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        GameManager.shared.updatePlayerScore(player: player, score: value)
    }
}


struct GameDetailPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let previewPlayer = Player(context: PersistenceController.preview.container.viewContext)
        previewPlayer.name = "Jožko Golonka"
        previewPlayer.score = 1000
        previewPlayer.id = UUID()
        
        
        return PlayerRow(player: previewPlayer)
        
    }
}
