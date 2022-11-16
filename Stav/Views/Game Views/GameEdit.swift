//
//  GameEdit.swift
//  Stav
//
//  Created by Samuel Tóth on 13/11/2022.
//

import SwiftUI
import CoreData

struct GameEdit: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var game: Game

    @State private var name: String = ""
    @State private var selectedColor: String
    @State private var selectedIcon: String = "number.circle.fill"
    
    private var players: [Player]

    private var isValid: Bool {
        !name.isEmpty && name.count < 16
    }
    
    init(game: Game) {
        self.game = game
        
        let playerRequest: NSFetchRequest<Player> = Player.fetchRequest()
        playerRequest.predicate = NSPredicate(format: "playerGame == %@", game)
        playerRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Player.name, ascending: true)]
        players = try! PersistenceController.shared.container.viewContext.fetch(playerRequest)
        
        self._name = State(initialValue: game.wrappedName)
        self._selectedColor = State(initialValue: game.wrappedColor)
        self._selectedIcon = State(initialValue: game.wrappedIcon)
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
                            .frame(width: 50, height: 50, alignment: .center)
                        Spacer()
                    }
                    TextField("name", text: $name)
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .onChange(of: name) { newValue in
                            name = String(newValue.prefix(10))
                        }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    List {
                        ForEach(players, id: \.id) { player in
                            HStack {
                                Image (systemName: "person.fill")
                                    .foregroundColor(.accentColor)
                                Text(player.wrappedName)
                            }
                        }
                        .onDelete(perform: deletePlayer)
                    }
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
                    Button("save", action: {
                        updateGame()
                    })
                    .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit \(game.wrappedName)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func updateGame() {
        if isValid {
            withAnimation {
                GameManager.shared.updateGame(game: game, name: name, icon: selectedIcon, color: selectedColor)
                dismiss()
            }
        }
    }
    
    private func deletePlayer(offsets: IndexSet) {
            offsets.map { players[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
    }
}


struct GameEdit_Previews: PreviewProvider {
    static var previews: some View {
        
        let previewGame = Game(context: PersistenceController.shared.container.viewContext)
        previewGame.id = UUID()
        previewGame.name = "NHL"
        previewGame.color = "picker_orange"
        previewGame.icon = "heart.circle.fill"
        previewGame.createdAt = Date()
        
        return GameEdit(game: previewGame).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
