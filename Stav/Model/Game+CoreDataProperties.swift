//
//  Game+CoreDataProperties.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var gamePlayers: NSSet?
    @NSManaged public var gameRecords: NSSet?

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
}

// MARK: Generated accessors for gamePlayers
extension Game {

    @objc(addGamePlayersObject:)
    @NSManaged public func addToGamePlayers(_ value: Player)

    @objc(removeGamePlayersObject:)
    @NSManaged public func removeFromGamePlayers(_ value: Player)

    @objc(addGamePlayers:)
    @NSManaged public func addToGamePlayers(_ values: NSSet)

    @objc(removeGamePlayers:)
    @NSManaged public func removeFromGamePlayers(_ values: NSSet)

}

// MARK: Generated accessors for gameRecords
extension Game {

    @objc(addGameRecordsObject:)
    @NSManaged public func addToGameRecords(_ value: GameRecord)

    @objc(removeGameRecordsObject:)
    @NSManaged public func removeFromGameRecords(_ value: GameRecord)

    @objc(addGameRecords:)
    @NSManaged public func addToGameRecords(_ values: NSSet)

    @objc(removeGameRecords:)
    @NSManaged public func removeFromGameRecords(_ values: NSSet)

}

extension Game : Identifiable {

}
