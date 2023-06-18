//
//  GameAddEdit.swift
//  Stav
//
//  Created by Samuel Tóth on 17/11/2022.
//

import SwiftUI
import SwiftData

struct PlayerTemplate: Identifiable {
    var id: UUID = UUID()
    var name: String
}

struct GameAddEdit: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedColor: String = "AccentColor"
    @State private var selectedIcon: String = "number.circle.fill"
    @State private var playerTemplates: [PlayerTemplate] = []
    
    private var players: [Player]?
    @Observable var game: Game?
    
    private var isValid: Bool {
        !name.isEmpty && name.count < 16 && !playerTemplates.isEmpty && playerTemplates.count < 9
        && playerTemplates.filter({ $0.name.isEmpty }).isEmpty
    }
    
    init(gameToEdit: Game? = nil ) {
        self.game = gameToEdit
        if let game = game {
            self.name = game.name
            self.selectedColor = game.color
            self.selectedIcon = game.icon
            self.players = game.players
            
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
                    TextField("name", text: $name)
                    .addNameStyle()
                    .onChange(of: name) { oldValue, newValue in
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
                                    Text(player.name)
                                }
                            }
                            .onDelete(perform: deletePlayer)
                        } else {
                            ForEach($playerTemplates, id: \.id) { player in
                                HStack {
                                    Image (systemName: "person.fill")
                                        .foregroundColor(.accentColor)
                                    TextField("playerName", text: player.name)
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
                    Text("players")
                }
                
                
                Section {
                    DisclosureGroup("selectColor") {
                        ColorPicker(selection: $selectedColor)
                    }
                    .listRowSeparator(.hidden)
                    
                    DisclosureGroup("selectIcon") {
                        IconPicker(selection: $selectedIcon, selectedColor: $selectedColor)
                    }
                    .listRowSeparator(.hidden)
                } header: {
                    Text("customize")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save", action: addOrUpdateGame)
                        .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("addGame")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let game = game {
                    name = game.name
                    selectedColor = game.color
                    selectedIcon = game.icon
                }
            }
        }
    }
    
    private func addOrUpdateGame() {
        if isValid {
            withAnimation {
                if (game != nil) {
                    game?.name = name
                    game?.icon = selectedIcon
                    game?.color = selectedColor
                } else {
                    let gameToAdd = Game(name: name, color: selectedColor, icon: selectedIcon)
                    modelContext.insert(gameToAdd)
                }
                
                try? modelContext.save()
                dismiss()
            }
        }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        if (game != nil) {
            withAnimation {
                for index in offsets {
                    game?.players.remove(at: index)
                    try? modelContext.save()
                }
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
