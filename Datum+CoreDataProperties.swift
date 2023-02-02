//
//  Datum+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 24/11/2022.
//
//

import Foundation
import CoreData


extension Datum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Datum> {
        return NSFetchRequest<Datum>(entityName: "Datum")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isRepeating: Bool
    @NSManaged public var name: String?
    @NSManaged public var repeatCycle: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var color: String?
    @NSManaged public var icon: String?
    @NSManaged public var createdAt: Date?

    var wrappedName: String {
        name ?? "Unknown Datum"
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

    var wrappedTimestamp: Date {
        timestamp ?? Date()
    }


}

extension Datum : Identifiable {

}
