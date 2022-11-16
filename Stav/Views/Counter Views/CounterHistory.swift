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
    
    private var historyRecords: [CounterHistoryRecord]
    private var counter: Counter
    
    init (counter: Counter, historyRecords: [CounterHistoryRecord]) {
        self.counter = counter
        self.historyRecords = historyRecords
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(historyRecords) { record in
                    HStack {
                        Text(record.wrappedTimestamp.dateToFormattedDatetime())
                        Spacer()
                        Text(record.value > 0 ? "+\(record.value)" : "\(record.value)")
                        Divider()
                        Text("\(record.result)")
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
            .navigationTitle("history \(counter.wrappedName)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct CounterHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newCounter = Counter(context: viewContext)
        newCounter.id = UUID()
        newCounter.name = "Test counter"
        newCounter.value = 3
        newCounter.createdAt = Date()
        newCounter.modifiedAt = Date()
        
        let newHistoryRecord = CounterHistoryRecord(context: viewContext)
        newHistoryRecord.id = UUID()
        newHistoryRecord.timestamp = Date()
        newHistoryRecord.value = 1
        newHistoryRecord.recordCounter = newCounter
        newHistoryRecord.result = newCounter.value
        
        return CounterHistory(counter: newCounter, historyRecords: [newHistoryRecord])
    }
}
