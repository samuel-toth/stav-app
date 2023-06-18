//
//  GameRow.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import SwiftUI

struct GameRow: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable private var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            Image(systemName: game.icon)
                .foregroundColor(Color(game.color))
                .font(.system(size: 25))
            VStack (alignment: HorizontalAlignment.leading) {
                Text(game.name)
                    .font(Font.system(.title3, design: .default))
                    .foregroundColor(Color(game.color))
                    .lineLimit(1)
                
                HStack {
                    Text("Hah")
                        .font(Font.system(.caption, design: .default))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            
            Spacer()
            
            HStack {
                Text("Hehe")
                    .valueDisplayStyle()
                Image(systemName: "person.2.fill")
                    .font(.title2)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, Color(UIColor.secondaryLabel))
            }
        }
        .contextMenu {
            Button {
                game.isFavourite.toggle()
                try? modelContext.save()
            } label: {
                Label(game.isFavourite ? "removeFavourite" : "markFavourite", systemImage: game.isFavourite ? "heart.slash" : "heart")
            }
        }
    }
}


//struct GameListRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        return List {
//            GameRow(game: previewGame)
//        }
//    }
//}
