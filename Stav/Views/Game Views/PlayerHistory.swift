//
//  PlayerHistory.swift
//  Stav
//
//  Created by Samuel Tóth on 13/11/2022.
//

import SwiftUI

struct PlayerHistory: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private var gameRecords: [HistoryRecord]
    private var playerName: String
    
    init(gameRecords: [HistoryRecord], playerName: String) {
        self.gameRecords = gameRecords
        self.playerName = playerName
        self.gameRecords.sort { $0.timestamp > $1.timestamp }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(gameRecords) { record in
                    HStack {
                        Text("\(record.totalValue)")
                            .fontWeight(.bold)
                            .frame(width: 50)
                        Divider()
                        Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                        Spacer()
                        Divider()
                        Text(record.timestamp.dateToFormattedDatetime() )
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


//struct PlayerHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        return PlayerHistory(gameRecords: [newRecord], playerName: previewPlayer.name ?? "")
//    }
//}
