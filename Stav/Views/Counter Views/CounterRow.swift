//
//  CounterRow.swift
//  Stav
//
//  Created by Samuel Tóth on 02/11/2022.
//

import SwiftUI
import SwiftData

struct CounterRow: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable private var counter: Counter
    @StateObject public var rT: RefreshTimer = RefreshTimer()
    
    init(counter: Counter) {
        self.counter = counter
    }
    
    var body: some View {
        HStack {
            Image(systemName: counter.icon)
                .foregroundColor(Color(counter.color))
                .font(.system(size: 25))
                
            VStack(alignment: HorizontalAlignment.leading) {
                Text(counter.name)
                    .font(Font.system(.title3, design: .default))
                    .foregroundColor(Color(counter.color))
                    .lineLimit(1)
                    
                Text(counter.modifiedAt.localizedTimeDifference())
                    .font(Font.system(.caption, design: .default))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            Spacer()
            
            HStack {
                Button("+") {
                }
                .font(.system(size: 44))
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    counter.value += 1
                    
                    let newHistoryRecord = HistoryRecord(value: 1, totalValue: counter.value)
                    counter.records.append(newHistoryRecord)
                    
                    try? modelContext.save()
                }
                Button("-") {
                }
                .padding(.horizontal, 10)
                .font(.system(size: 44))
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    counter.value -= 1
                    
                    let newHistoryRecord = HistoryRecord(value: -1, totalValue: counter.value)
                    counter.records.append(newHistoryRecord)
                    
                    try? modelContext.save()

                }
            }
            
            Divider()
            
            Text("\(counter.value)")
                .valueDisplayStyle()
        }

        .contextMenu {
            Button {
                counter.isFavourite.toggle()
                try? modelContext.save()
            } label: {
                Label(counter.isFavourite ? "removeFavourite" : "markFavourite", systemImage: counter.isFavourite ? "heart.slash" : "heart")
            }
            
            // TODO: Implement export for one counter
            Button {
                
            } label: {
                Label("exportHistory", systemImage: "arrow.up.doc")
            }
            Divider()
            Button(role: .destructive) {
                withAnimation {
                    modelContext.delete(counter)
                    try? modelContext.save()

                }
            } label: {
                Label("delete", systemImage: "trash")
            }
        }
    }
}


//struct CounterListRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        return List {
//            CounterRow(counter: newCounter)
//        }
//    }
//}
