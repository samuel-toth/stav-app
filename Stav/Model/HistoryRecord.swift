//
//  SDHistoryRecord.swift
//  Stav
//
//  Created by Samuel Tóth on 17/06/2023.
//

import Foundation
import SwiftData

@Model
class HistoryRecord {
    
    var id: UUID
    @Attribute(.unique) var timestamp: Date
    var value: Int
    var totalValue: Int
    
    init(timestamp: Date = Date.now, value: Int, totalValue: Int) {
        self.id = UUID()
        self.timestamp = timestamp
        self.value = value
        self.totalValue = totalValue
    }
}
