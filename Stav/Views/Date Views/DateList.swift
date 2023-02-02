//
//  DateList.swift
//  Stav
//
//  Created by Samuel Tóth on 23/11/2022.
//

import SwiftUI

struct DateList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Datum.name, ascending: true)])
    private var dates: FetchedResults<Datum>
    
    @State private var isSheetPresented: Bool = false
    @State private var showFavourite: Bool = false
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(dates) { date in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                                .scaledToFill()
                            
                            VStack {
                                Text(date.name ?? "")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(date.color!))
                                    .fontWeight(.semibold)

                                Spacer()

                                HStack {
                                  
                                    Text("\(date.wrappedTimestamp.getDifferenceLocalized().0)")
                                        .font(.system(size: 50))
                                        .foregroundColor(Color(date.color!))
                                        .fontWeight(.heavy)
                                        .truncationMode(.middle)
                                        .lineLimit(1)

                                }
                                Spacer()

                                HStack {
                                    Text("\(date.wrappedTimestamp.getDifferenceLocalized().1)")
                                        .font(.footnote)                     .foregroundColor(Color(UIColor.secondaryLabel))
                                        .padding(.horizontal, -5)
                                    Text((date.wrappedTimestamp.isPast()) ? "havePassed" : "remaining").multilineTextAlignment(.trailing).font(.footnote)
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                }
                                
                                Spacer()
                            }
                            .padding()
                            
                        }
                        
                        .padding(6)
                        .contextMenu {
                            Button {
                                DatumManager.shared.toggleFavourite(datum: date)
                            } label: {
                                Label(date.isFavourite ? "removeFavourite".localized() : "markFavourite".localized(), systemImage: date.isFavourite ? "heart.slash" : "heart")
                            }

                            Button(role: .destructive) {
                                withAnimation {
                                    DatumManager.shared.deleteDatum(datum: date)
                                }
                               
                            } label: {
                                Label("delete".localized(), systemImage: "trash")
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
                                dates.nsPredicate = showFavourite ?  NSPredicate(format: "isFavourite == %@", NSNumber(value: showFavourite)) : NSPredicate(format: "isFavourite == YES OR isFavourite == NO")
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
    
    private func deleteDate(offsets: IndexSet) {
        withAnimation {
            offsets.map { dates[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DateList_Previews: PreviewProvider {
    static var previews: some View {
        DateList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
