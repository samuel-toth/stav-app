//
//  CounterList.swift
//  Stav
//
//  Created by Samuel Tóth on 02/11/2022.
//

import SwiftUI
import CoreData
import SwiftData

struct CounterList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.name) var allCounters: [Counter]
    
    @State private var isSheetPresented: Bool = false
    @State private var showFavourite: Bool = false
    
    // MARK: Sort variables
    @State private var selectedSort: SelectedSort = .name
    @State private var sortAscending: Bool = true
    
    private var sortedCounters : [Counter] {
        return allCounters.filter {
            showFavourite ? $0.isFavourite : true
        } .sorted {
            switch selectedSort {
            case .name:
                $0.name < $1.name
            case .value:
                $0.value < $1.value
            case .modified:
                $0.modifiedAt < $1.modifiedAt
            }
        } .reverse(condition: sortAscending)
    }
    
    var body: some View {
        NavigationStack {
            if allCounters.isEmpty {
                Image("AppIconNoBg")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.1)
            }
            List {
                ForEach(sortedCounters) { counter in
                    NavigationLink(value: counter) {
                        CounterRow(counter: counter)
                            .frame(height: 50)
                    }
                }
                .onDelete(perform: deleteCounter)
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground).opacity(0.8))
                
            }
            .navigationDestination(for: Counter.self, destination: { counter in
                CounterDetail(counter: counter)
            })

            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isSheetPresented.toggle()
                    }) {
                        Label("add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            showFavourite.toggle()
                        }) {
                            Label(showFavourite ? "showAllCounters" : "showFavourites", systemImage: showFavourite ? "heart.slash" : "heart")
                        }
                        
                        Menu {
                            Button(action: {
                                selectedSort = .name
                                sortAscending.toggle()
                            }) {
                                Label("name", systemImage: selectedSort == .name ? (sortAscending ? "arrow.up" : "arrow.down" ): "")
                            }
                            Button(action: {
                                selectedSort = .value
                                sortAscending.toggle()
                            }) {
                                Label("value", systemImage: selectedSort == .value ? (sortAscending ? "arrow.up" : "arrow.down" ): "")
                            }
                            
                            Button(action: {
                                selectedSort = .modified
                                sortAscending.toggle()
                            }) {
                                Label("modified", systemImage: selectedSort == .modified ? (sortAscending ? "arrow.down" : "arrow.up" ): "")
                            }
                        } label: {
                            Label("sortBy", systemImage: "arrow.up.arrow.down")
                        }
                        
                        // TODO: Implement import export
                        Section(header: Text("settings")) {
                            Button(action: {}) {
                                Label("importCounters", systemImage: "arrow.down.doc")
                            }
                            Button(action: {}) {
                                Label("exportCounters", systemImage: "arrow.up.doc")
                            }
                        }
                    }
                label: {
                    Label("add", systemImage: "ellipsis")
                }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                CounterAddEdit()
            }
            .navigationTitle("counters")
        }
    }
    
    private func deleteCounter(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(allCounters[index])
                try? modelContext.save()
            }
        }
    }
}


struct CounterListView_Previews: PreviewProvider {
    static var previews: some View {
        CounterList()
    }
}

extension Array {
    func reverse(condition: Bool) -> [Element] {
        condition ? self.reversed() : self
    }
}
