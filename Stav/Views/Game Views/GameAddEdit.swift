//
//  GameAddEdit.swift
//  Stav
//
//  Created by Samuel Tóth on 17/11/2022.
//

import SwiftUI

struct PlayerTemplate: Identifiable {
    var id: UUID = UUID()
    var name: String
}

struct GameAddEdit: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "number.circle.fill"
    @State private var playerTemplates: [PlayerTemplate] = []
    
    private var players: [Player]?
    var game: Game?


    
    private var isValid: Bool {
        !name.isEmpty && name.count < 16 && !playerTemplates.isEmpty && playerTemplates.count < 9
        && playerTemplates.filter({ $0.name.isEmpty }).isEmpty
    }
    
    init(gameToEdit: Game? = nil ) {
        self.game = gameToEdit
        if let game = game {
            self.name = game.wrappedName
            self.selectedColor = game.wrappedColor
            self.selectedIcon = game.wrappedIcon
            self.players = game.gamePlayers?.toArray()
            
        }
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

                        if (game != nil) {
                            ForEach(players!, id: \.id) { player in
                                HStack {
                                    Image (systemName: "person.fill")
                                            .foregroundColor(.accentColor)
                                    Text(player.wrappedName)
                                }
                            }
                                    .onDelete(perform: deletePlayer)
                        } else {
                            ForEach($playerTemplates, id: \.id) { player in
                                HStack {
                                    Image (systemName: "person.fill")
                                            .foregroundColor(.accentColor)
                                    TextField("playerName".localized(), text: player.name)
                                            .multilineTextAlignment(.leading)
                                }
                            }
                                    .onDelete(perform: deletePlayer)
                        }

                    }

                    Button(action: {
                        playerTemplates.append(PlayerTemplate(name:""))
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
                    Button("save".localized(), action: addOrUpdateGame)
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
                    .onAppear {
                        if let game = game {
                            name = game.wrappedName
                            selectedColor = game.wrappedColor
                            selectedIcon = game.wrappedIcon
                        }
                    }
        }
    }
    
    private func addOrUpdateGame() {
        if isValid {
            withAnimation {
                if (game != nil) {
                    GameManager.shared.updateGame(game: game!, name: name, icon: selectedIcon, color: selectedColor)
                } else {
                    GameManager.shared.addGame(name: name, icon: selectedIcon, color: selectedColor, players: playerTemplates)
                }
               
                dismiss()
            }
        }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        if (game != nil) {
            offsets.map { players![$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        } else {
            playerTemplates.remove(atOffsets: offsets)
        }
    }
}

struct GameAddEdit_Previews: PreviewProvider {
    static var previews: some View {
        GameAddEdit()
    }
}
