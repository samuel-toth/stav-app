//
//  SDPlayer.swift
//  Stav
//
//  Created by Samuel Tóth on 18/06/2023.
//

import Foundation
import SwiftData

@Model
class Player {
    var id: UUID
    var createdAt: Date
    var modifiedAt: Date
    var name: String
    var score: Int
    @Relationship(.cascade) var records: [HistoryRecord] = []
    
    var game: Game?
    
    init(name: String, score: Int) {
        self.id = UUID()
        self.createdAt = Date.now
        self.modifiedAt = Date.now
        self.name = name
        self.score = score
    }
}
