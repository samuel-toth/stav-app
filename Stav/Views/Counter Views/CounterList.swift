//
//  CounterList.swift
//  Stav
//
//  Created by Samuel Tóth on 02/11/2022.
//

import SwiftUI
import CoreData

struct CounterList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Counter.name, ascending: true)])
    private var counters: FetchedResults<Counter>
    
    @State private var isSheetPresented: Bool = false
    @State private var showFavourite: Bool = false
    
    // MARK: Sort variables
    @State private var selectedSort: SelectedSort = .name
    @State private var sortNameAscending: Bool = true
    @State private var sortValueAscending: Bool = true
    @State private var sortModifiedAscending: Bool = true
    
    
    var body: some View {
        
        NavigationStack {
            if counters.isEmpty {
                Image("AppIconNoBg")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.2)
            }
            List {
                
                ForEach(counters) { counter in
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
                    .environment(\.managedObjectContext, viewContext)
            })
            .shadow(radius: 5, x: 0, y: 5)
            .scrollContentBackground(.hidden) // new in
//            .background {
//                Image("AppIconNoBg")
//                    .resizable()
//                    .scaledToFit()
//                    .opacity(0.2)
//            }
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
                            counters.nsPredicate = showFavourite ?  NSPredicate(format: "isFavourite == %@", NSNumber(value: showFavourite)) : NSPredicate(format: "isFavourite == YES OR isFavourite == NO")
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
    
    private func sortCounters() {
        switch selectedSort {
        case .name:
            sortNameAscending.toggle()
            counters.nsSortDescriptors = [NSSortDescriptor(keyPath: \Counter.name, ascending: sortNameAscending)]
        case .value:
            sortValueAscending.toggle()
            counters.nsSortDescriptors = [NSSortDescriptor(keyPath: \Counter.value, ascending: sortValueAscending)]
        case .modified:
            sortModifiedAscending.toggle()
            counters.nsSortDescriptors = [NSSortDescriptor(keyPath: \Counter.modifiedAt, ascending: sortModifiedAscending)]
        }
    }
    
    private func deleteCounter(offsets: IndexSet) {
        withAnimation {
            offsets.map { counters[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct CounterListView_Previews: PreviewProvider {
    static var previews: some View {
        CounterList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
