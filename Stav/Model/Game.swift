//
//  SDGame.swift
//  Stav
//
//  Created by Samuel Tóth on 18/06/2023.
//

import Foundation
import SwiftData

@Model
class Game {
    var id: UUID
    var name: String
    var color: String
    var createdAt: Date
    var icon: String
    var isFavourite: Bool
    @Relationship(.cascade, inverse: \Player.game) var players: [Player] = []
    
    init(name: String, color: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.createdAt = Date.now
        self.icon = icon
        self.isFavourite = false
    }

}
