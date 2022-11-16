//
//  CounterRow.swift
//  Stav
//
//  Created by Samuel Tóth on 02/11/2022.
//

import SwiftUI

struct CounterRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var counter: Counter
    @StateObject public var rT: RefreshTimer = RefreshTimer()

    init(counter: Counter) {
        self.counter = counter
    }
    
    var body: some View {
        HStack {
            Image(systemName: counter.wrappedIcon)
                .foregroundColor(Color(counter.wrappedColor))
                .font(.system(size: 25))
                
            VStack(alignment: HorizontalAlignment.leading) {
                Text(counter.wrappedName)
                    .font(Font.system(.title3, design: .default))
                    .foregroundColor(Color(counter.wrappedColor))
                    .lineLimit(1)
                    
                Text(counter.wrappedModifiedAt.localizedTimeDifference())
                    .font(Font.system(.caption, design: .default))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            Spacer()
            
            HStack {
                Button("+") {
                    CounterManager.shared.updateCounterValue(counter: counter, value: 1)
                }
                .font(.system(size: 44))
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    CounterManager.shared.updateCounterValue(counter: counter, value: 1)
                }
                
                Button("-") {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    CounterManager.shared.updateCounterValue(counter: counter, value: -1)
                }
                .padding(.horizontal, 10)
                .font(.system(size: 44))
                .onTapGesture {
                    CounterManager.shared.updateCounterValue(counter: counter, value: -1)
                }
            }
            
            Divider()
            
            Text("\(counter.value)")
                .valueDisplayStyle()
        }
        .contextMenu {
            Button {
                CounterManager.shared.toggleFavourite(counter: counter)
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
                    CounterManager.shared.deleteCounter(counter: counter)
                }
            } label: {
                Label("delete", systemImage: "trash")
            }
        }
    }
}


struct CounterListRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        let newCounter = Counter(context: PersistenceController.preview.container.viewContext)
        
        newCounter.name = "test"
        newCounter.value = 2666
        newCounter.modifiedAt = Date(timeIntervalSinceNow: -250)
        
        return List {
            CounterRow(counter: newCounter).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
