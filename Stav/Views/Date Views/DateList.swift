//
//  DateList.swift
//  Stav
//
//  Created by Samuel Tóth on 23/11/2022.
//

import SwiftUI
import SwiftData

struct DateList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.name) var allDatums: [Datum]
    
    @State private var isSheetPresented: Bool = false
    @State private var showFavourite: Bool = false
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(allDatums) { datum in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                                .scaledToFill()
                            
                            VStack {
                                Text(datum.name )
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(datum.color!))
                                    .fontWeight(.semibold)

                                Spacer()

                                HStack {
                                    Text("\(datum.timestamp.getDifferenceLocalized().0)")
                                        .font(.system(size: 50))
                                        .foregroundColor(Color(datum.color!))
                                        .fontWeight(.heavy)
                                        .truncationMode(.middle)
                                        .lineLimit(1)

                                }
                                Spacer()

                                HStack {
                                    Text("\(datum.timestamp.getDifferenceLocalized().1)")
                                        .font(.footnote)
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                        .padding(.horizontal, -5)
                                    Text((datum.timestamp.isPast()) ? "havePassed" : "remaining").multilineTextAlignment(.trailing).font(.footnote)
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                }
                                
                                Spacer()
                            }
                            .padding()
                            
                        }
                        
                        .padding(6)
                        .contextMenu {
                            Button {
                                datum.isFavourite.toggle()
                                
                                try? modelContext.save()
                            } label: {
                                Label(datum.isFavourite ? "removeFavourite" : "markFavourite", systemImage: datum.isFavourite ? "heart.slash" : "heart")
                            }

                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(datum)
                                }
                               
                            } label: {
                                Label("delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.horizontal,10)
                .padding(.top, -6)
            }

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
                        Section {
                            Button(action: {
                                showFavourite.toggle()
                                // TODO: Show favourite datums
                            }) {
                                Label(showFavourite ? "showAllGames" : "showFavourites", systemImage: showFavourite ? "heart.slash" : "heart")
                            }
                        }
                    } label: {Label("add", systemImage: "ellipsis")}
                }
            }
            .sheet(isPresented: $isSheetPresented, content: {
                DateAddEdit()
            })
            .navigationTitle("dates")
        }
    
    }
    
    private func deleteDatum(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(allDatums[index])
                try? modelContext.save()
            }
        }
    }
}

struct DateList_Previews: PreviewProvider {
    static var previews: some View {
        DateList()
    }
}
