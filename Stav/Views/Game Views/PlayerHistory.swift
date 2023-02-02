//
//  PlayerHistory.swift
//  Stav
//
//  Created by Samuel Tóth on 13/11/2022.
//

import SwiftUI

struct PlayerHistory: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private var gameRecords: [Record]
    private var playerName: String
    
    init(gameRecords: [Record], playerName: String) {
        self.gameRecords = gameRecords
        self.playerName = playerName
        self.gameRecords.sort { $0.timestamp ?? Date() > $1.timestamp ?? Date() }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(gameRecords) { record in
                    HStack {
                        Text("\(record.result)")
                            .fontWeight(.bold)
                            .frame(width: 50)
                        Divider()
                        Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                        Spacer()
                        Divider()
                        Text(record.timestamp?.dateToFormattedDatetime() ?? "")
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("return", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("history \(playerName)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct PlayerHistory_Previews: PreviewProvider {
    static var previews: some View {
        let previewPlayer = Player(context: PersistenceController.preview.container.viewContext)
        previewPlayer.name = "Jožko Golonka"
        previewPlayer.score = 20
        previewPlayer.id = UUID()
        
        let newRecord = Record(context: PersistenceController.preview.container.viewContext)
        newRecord.id = UUID()
        newRecord.timestamp = Date()
        newRecord.value = 1
        newRecord.result = 20
        newRecord.player = previewPlayer
        
        return PlayerHistory(gameRecords: [newRecord], playerName: previewPlayer.name ?? "")
    }
}
