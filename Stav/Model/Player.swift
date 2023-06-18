//
//  SDPlayer.swift
//  Stav
//
//  Created by Samuel Tóth on 18/06/2023.
//

import Foundation
import SwiftData

@Model
class SDPlayer {
    var id: UUID
    var createdAt: Date
    var modifiedAt: Date
    var name: String
    var score: Int
    @Relationship(.cascade) var records: [SDHistoryRecord] = []
    
    var game: SDGame?
    
    init(name: String, score: Int) {
        self.id = UUID()
        self.createdAt = Date.now
        self.modifiedAt = Date.now
        self.name = name
        self.score = score
    }
}
