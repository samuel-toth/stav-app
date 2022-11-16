//
//  GameRow.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct GameRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var game: Game
    
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            Image(systemName: game.wrappedIcon)
                .foregroundColor(Color(game.wrappedColor))
                .font(.system(size: 25))
            VStack (alignment: HorizontalAlignment.leading) {
                Text(game.name ?? "")
                    .font(Font.system(.title3, design: .default))
                    .foregroundColor(Color(game.wrappedColor))
                    .lineLimit(1)
                
                HStack {
                    Text(GameManager.shared.getLocalizedGameResult(id: game.id ?? UUID()))
                        .font(Font.system(.caption, design: .default))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            Spacer()
            HStack {
                Text("\(GameManager.shared.getGamePlayersCount(id: game.id ?? UUID()))")
                    .valueDisplayStyle()
                Image(systemName: "person.2.fill")
                    .font(.title2)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, Color(UIColor.secondaryLabel))
            }
        }
        .contextMenu {
            Button {
                GameManager.shared.toggleFavourite(game: game)
            } label: {
                Label(game.isFavourite ? "removeFavourite".localized() : "markFavourite".localized(), systemImage: game.isFavourite ? "heart.slash" : "heart")
            }
        }
    }
}


struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let previewGame = Game(context: PersistenceController.preview.container.viewContext)
        previewGame.name = "test"
        
        return List {
            GameRow(game: previewGame).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
