//
//  SDDatum.swift
//  Stav
//
//  Created by Samuel Tóth on 18/06/2023.
//

import Foundation
import SwiftData

@Model
class Datum {
    var id: UUID
    var name: String
    var isFavourite: Bool
    var isRepeating: Bool
    var repeatCycle: String
    var timestamp: Date
    var color: String?
    var icon: String?
    var createdAt: Date
    
    init(name: String, isRepeating: Bool, repeatCycle: String, timestamp: Date, color: String? = nil, icon: String? = nil) {
        self.id = UUID()
        self.isFavourite = false
        self.isRepeating = isRepeating
        self.name = name
        self.repeatCycle = repeatCycle
        self.timestamp = timestamp
        self.color = color
        self.icon = icon
        self.createdAt = Date.now
    }
}
