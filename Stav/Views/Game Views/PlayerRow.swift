//
//  PlayerRow.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI
import SwiftData

struct PlayerRow: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable private var player: Player
    
    @State private var showPlayerHistory = false
    @State private var showRenamePlayer = false
    @State private var playerNewName = ""
    
    init(player: Player) {
        self.player = player
    }
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(Color(player.game!.color))
            VStack(alignment: .leading) {
                Text(player.name )
                    .font(Font.system(.title3, design: .default))
                    .lineLimit(1)
                Text(player.modifiedAt.localizedTimeDifference() )
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
        .alert("renamePlayer \(player.name)", isPresented: $showRenamePlayer, actions: {
            TextField("newName", text: $playerNewName)
            
            Button("rename", action: {
                withAnimation {
                    player.name = playerNewName
                    try? modelContext.save()
                    playerNewName = ""
                }
            })
            Button("cancel", role: .cancel, action: {})})
        .padding()
        .frame(height: 70)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//        .sheet(isPresented: $showPlayerHistory) {
//            PlayerHistory(gameRecords: player.records?.toArray() ?? [], playerName: player.wrappedName)
//        }
        .contextMenu {
            Button {
                showRenamePlayer.toggle()
            } label: {
                Label("renamePlayer \(player.name)", systemImage: "person.text.rectangle")
            }
            
            Button {
                showPlayerHistory.toggle()
            } label: {
                Label("showHistory", systemImage: "arrow.up.doc")
            }
            
            Button {
            } label: {
                Label("resetPlayer \(player.name)", systemImage: "arrow.counterclockwise.circle")
            }
        }
    }
    
    func updateValue(value: Int) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}


//struct GameDetailPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        return PlayerRow(player: previewPlayer)
//        
//    }
//}
