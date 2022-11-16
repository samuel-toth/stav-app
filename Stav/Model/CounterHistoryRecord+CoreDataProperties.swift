//
//  CounterHistoryRecord+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//
//

import Foundation
import CoreData


extension CounterHistoryRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CounterHistoryRecord> {
        return NSFetchRequest<CounterHistoryRecord>(entityName: "CounterHistoryRecord")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var result: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var value: Int16
    @NSManaged public var recordCounter: Counter?

    public var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
}

extension CounterHistoryRecord : Identifiable {

}
