//
//  SDCounter.swift
//  Stav
//
//  Created by Samuel Tóth on 17/06/2023.
//

import Foundation
import SwiftData

@Model
class Counter {

    var id: UUID
    @Attribute(.unique) var name: String
    var value: Int
    var isFavourite: Bool
    var hasGoal: Bool
    var goalDate: Date?
    var goalValue: Int?
    var color: String?
    var icon: String?
    var createdAt: Date
    var modifiedAt: Date
    @Relationship(.cascade) var records: [HistoryRecord] = []
    
    init(name: String, value: Int, hasGoal: Bool, goalDate: Date? = nil, goalValue: Int? = nil, color: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.value = value
        self.isFavourite = false
        self.hasGoal = hasGoal
        self.goalDate = goalDate
        self.goalValue = goalValue
        self.color = color
        self.icon = icon
        self.createdAt = Date.now
        self.modifiedAt = Date.now
    }
}
