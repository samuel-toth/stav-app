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
    @State private var sortNameAscending: Bool = true
    @State private var sortValueAscending: Bool = true
    @State private var sortModifiedAscending: Bool = true
    
    var body: some View {
        NavigationStack {
            if allCounters.isEmpty {
                Image("AppIconNoBg")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.1)
            }
            List {
                ForEach(allCounters) { counter in
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
                            // TODO: Show favourite counters
                        }) {
                            Label(showFavourite ? "showAllCounters" : "showFavourites", systemImage: showFavourite ? "heart.slash" : "heart")
                        }
                        
                        Menu {
                            Button(action: {
                                selectedSort = .name
                                sortCounters()
                            }) {
                                Label("name", systemImage: selectedSort == .name ? (sortNameAscending ? "arrow.up" : "arrow.down" ): "")
                            }
                            Button(action: {
                                selectedSort = .value
                                sortCounters()
                            }) {
                                Label("value", systemImage: selectedSort == .value ? (sortValueAscending ? "arrow.up" : "arrow.down" ): "")
                            }
                            
                            Button(action: {
                                selectedSort = .modified
                                sortCounters()
                            }) {
                                Label("modified", systemImage: selectedSort == .modified ? (sortModifiedAscending ? "arrow.up" : "arrow.down" ): "")
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
    
    // TODO: counter sorting
    private func sortCounters() {
        switch selectedSort {
        case .name:
            sortNameAscending.toggle()
        case .value:
            sortValueAscending.toggle()
        case .modified:
            sortModifiedAscending.toggle()
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
