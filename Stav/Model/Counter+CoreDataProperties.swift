//
//  Counter+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
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
    @NSManaged public var historyRecords: NSSet?

    public var wrappedName: String {
        name ?? "Unknown name"
    }

    public var wrappedColor: String {
        color ?? "AccentColor"
    }

    public var wrappedIcon: String {
        icon ?? "exclamationmark.circle"
    }

    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    public var wrappedModifiedAt: Date {
        modifiedAt ?? Date()
    }

    public var wrappedGoalDate: Date {
        goalDate ?? Date()
    }




}

// MARK: Generated accessors for historyRecords
extension Counter {

    @objc(addHistoryRecordsObject:)
    @NSManaged public func addToHistoryRecords(_ value: CounterHistoryRecord)

    @objc(removeHistoryRecordsObject:)
    @NSManaged public func removeFromHistoryRecords(_ value: CounterHistoryRecord)

    @objc(addHistoryRecords:)
    @NSManaged public func addToHistoryRecords(_ values: NSSet)

    @objc(removeHistoryRecords:)
    @NSManaged public func removeFromHistoryRecords(_ values: NSSet)

}

extension Counter : Identifiable {

}
