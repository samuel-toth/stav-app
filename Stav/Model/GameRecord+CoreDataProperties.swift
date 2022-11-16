//
//  GameRecord+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//
//

import Foundation
import CoreData


extension GameRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameRecord> {
        return NSFetchRequest<GameRecord>(entityName: "GameRecord")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var result: Int32
    @NSManaged public var timestamp: Date?
    @NSManaged public var value: Int32
    @NSManaged public var recordGame: Game?
    @NSManaged public var recordPlayer: Player?

    public var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
}

extension GameRecord : Identifiable {

}
