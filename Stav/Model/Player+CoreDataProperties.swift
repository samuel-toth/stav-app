//
//  Player+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var modifiedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var score: Int32
    @NSManaged public var playerGame: Game?
    @NSManaged public var playerRecords: NSSet?

    public var wrappedName: String {
        name ?? "Unknown name"
    }

    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    public var wrappedModifiedAt: Date {
        modifiedAt ?? Date()
    }
}

// MARK: Generated accessors for playerRecords
extension Player {

    @objc(addPlayerRecordsObject:)
    @NSManaged public func addToPlayerRecords(_ value: GameRecord)

    @objc(removePlayerRecordsObject:)
    @NSManaged public func removeFromPlayerRecords(_ value: GameRecord)

    @objc(addPlayerRecords:)
    @NSManaged public func addToPlayerRecords(_ values: NSSet)

    @objc(removePlayerRecords:)
    @NSManaged public func removeFromPlayerRecords(_ values: NSSet)

}

extension Player : Identifiable {

}
