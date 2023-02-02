//
//  Player+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 18/11/2022.
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
    @NSManaged public var score: Int16
    @NSManaged public var game: Game?
    @NSManaged public var records: NSSet?

    var wrappedName: String {
        name ?? "Unknown Player"
    }

    var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    var wrappedModifiedAt: Date {
        modifiedAt ?? Date()
    }
}

// MARK: Generated accessors for records
extension Player {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: Record)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: Record)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}

extension Player : Identifiable {

}
