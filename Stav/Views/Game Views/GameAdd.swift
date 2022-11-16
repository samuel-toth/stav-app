//
//  GameAdd.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct PlayerTemplate: Identifiable {
    var id: UUID = UUID()
    var name: String
}

struct GameAdd: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "number.circle.fill"
    @State private var players: [PlayerTemplate] = []
    
    private var isValid: Bool {
        !name.isEmpty && name.count < 16 && !players.isEmpty && players.count < 9
        && players.filter({ $0.name.isEmpty }).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: selectedIcon)
                            .resizable()
                            .foregroundColor(Color(selectedColor))
                            .frame(width: 100, height: 100, alignment: .center)
                        Spacer()
                    }
                    TextField("name".localized(), text: $name)
                        .addNameStyle()
                        .onChange(of: name) { newValue in
                            name = String(newValue.prefix(10))
                        }

                }
                .listRowSeparator(.hidden)
                
                Section {
                    List {
                        ForEach($players, id: \.id) { player in
                            HStack {
                                Image (systemName: "person.fill")
                                    .foregroundColor(.accentColor)
                                TextField("playerName".localized(), text: player.name)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .onDelete(perform: deletePlayer)
                    }
                    
                    Button(action: {
                        players.append(PlayerTemplate(name:""))
                    }, label: {
                        HStack {
                            Spacer()
                            Image (systemName: "plus.circle")
                                .font(.title2)
                        }
                    })
                } header: {
                    Text("players".localized())
                }
                
                
                Section {
                    DisclosureGroup("selectColor".localized()) {
                        ColorPicker(selection: $selectedColor)
                    }
                    .listRowSeparator(.hidden)
                    
                    DisclosureGroup("selectIcon".localized()) {
                        IconPicker(selection: $selectedIcon, selectedColor: $selectedColor)
                    }
                    .listRowSeparator(.hidden)
                } header: {
                    Text("customize".localized())
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save".localized(), action: addGame)
                        .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized(), role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("addGame".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addGame() {
        if isValid {
            withAnimation {
                GameManager.shared.addGame(name: name, icon: selectedIcon, color: selectedColor, players: players)
                dismiss()
            }
        }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
    }
}


struct GameAddView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background").sheet(isPresented: .constant(true)) {
            GameAdd().environment(\.locale, .init(identifier: "sk"))

        }
    }
}

