//
//  GameHistory.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct GameHistory: View {
    
    @Environment(\.dismiss) private var dismiss

    private var gameRecords: [HistoryRecord]
    private var gameName: String
    
    init(gameName: String, gameRecords: [HistoryRecord]) {
        self.gameRecords = gameRecords
        self.gameName = gameName
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(gameRecords) { record in
                    HStack {
                        Text("\(record.totalValue)")
                            .fontWeight(.bold)
                            .frame(width: 50)
                            .multilineTextAlignment(.leading)
                        Divider()
                        Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                        Spacer()
//                        Text(record.player?.name ?? "")
//                            .multilineTextAlignment(.trailing)
                        Divider()
                        Text(record.timestamp.dateToFormattedDatetime())
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

//struct GameHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        return GameHistory(gameName: "Test name", gameRecords: [newRecord])
//    }
//}
