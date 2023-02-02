//
//  Record+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 18/11/2022.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var result: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var value: Int16
    @NSManaged public var counter: Counter?
    @NSManaged public var game: Game?
    @NSManaged public var player: Player?

    var wrappedId: UUID {
        id ?? UUID()
    }

    var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
}

extension Record : Identifiable {

}
