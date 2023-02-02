//
//  Counter+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 18/11/2022.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var goalDate: Date?
    @NSManaged public var goalValue: Int16
    @NSManaged public var hasGoal: Bool
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var modifiedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var value: Int16
    @NSManaged public var records: NSSet?

    var wrappedName: String {
        name ?? "Unknown Counter"
    }

    var wrappedColor: String {
        color ?? "AccentColor"
    }

    var wrappedIcon: String {
        icon ?? "exclamationmark.circle"
    }

    var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    var wrappedModifiedAt: Date {
        modifiedAt ?? Date()
    }

    var wrappedGoalDate: Date {
        goalDate ?? Date()
    }
}

// MARK: Generated accessors for records
extension Counter {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: Record)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: Record)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}

extension Counter : Identifiable {

}
