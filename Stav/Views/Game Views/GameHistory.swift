//
//  GameHistory.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct GameHistory: View {
    
    @Environment(\.dismiss) private var dismiss

    private var gameRecords: [Record]
    private var gameName: String
    
    init(gameName: String, gameRecords: [Record]) {
        self.gameRecords = gameRecords
        self.gameName = gameName
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(gameRecords) { record in
                    HStack {
                        Text("\(record.result)")
                            .fontWeight(.bold)
                            .frame(width: 50)
                            .multilineTextAlignment(.leading)
                        Divider()
                        Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                        Spacer()
                        Text(record.player?.name ?? "")
                            .multilineTextAlignment(.trailing)
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
            .navigationTitle("history \(gameName)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GameHistory_Previews: PreviewProvider {
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

        return GameHistory(gameName: "Test name", gameRecords: [newRecord])
    }
}
