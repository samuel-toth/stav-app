//
//  CounterHistory.swift
//  Stav
//
//  Created by Samuel Tóth on 08/11/2022.
//

import SwiftUI


// TODO: Merge with GameHistory to one view
struct CounterHistory: View {
    @Environment(\.dismiss) private var dismiss
    
    private var historyRecords: [HistoryRecord]
    private var counter: Counter
    
    init (counter: Counter, historyRecords: [HistoryRecord]) {
        self.counter = counter
        self.historyRecords = historyRecords
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(historyRecords) { record in
                    HStack {
                        Text(record.timestamp.dateToFormattedDatetime())
                        Spacer()
                        Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                        Divider()
                        Text("\(record.totalValue)")
                            .fontWeight(.bold)
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
            .navigationTitle("history \(counter.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


//struct CounterHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        return CounterHistory(counter: newCounter, historyRecords: [newHistoryRecord])
//    }
//}
