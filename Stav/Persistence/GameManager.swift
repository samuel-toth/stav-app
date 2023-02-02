//
//  GameManager.swift
//  Stav
//
//  Created by Samuel Tóth on 11/11/2022.
//

import Foundation
import CoreData

class GameManager {
    
    static let shared = GameManager()
    
    private var viewContext = PersistenceController.shared.container.viewContext
    
    func addGame(name: String, icon: String, color: String, players: [PlayerTemplate]){
        let newGame = Game(context: viewContext)
        newGame.id = UUID()
        newGame.name = name
        newGame.createdAt = Date()
        newGame.color = color
        newGame.icon = icon

        for player in players {
            let newPlayer = Player(context: viewContext)
            newPlayer.id = UUID()
            newPlayer.name = player.name
            newPlayer.game = newGame
            newPlayer.createdAt = Date()
            newPlayer.modifiedAt = Date()
        }
        
        save()
    }

    func toggleFavourite(game: Game) {
        game.isFavourite.toggle()
        save()
    }

    func addPlayerToGame(game: Game, playerName: String){
        let newPlayer = Player(context: viewContext)
        newPlayer.id = UUID()
        newPlayer.name = playerName
        newPlayer.game = game
        newPlayer.createdAt = Date()
        newPlayer.modifiedAt = Date()

        save()
    }

    func deletePlayer(player: Player){
        viewContext.delete(player)
        save()
    }

    func getGame(id: UUID) -> Game? {
        let request: NSFetchRequest<Game> = Game.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteGame(game: Game) {
        viewContext.delete(game)
        save()
    }

    func getGamePlayersCount(id: UUID) -> Int {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "game.id == %@", id as CVarArg)

        do {
            let result = try viewContext.fetch(request)
            return result.count
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func getLocalizedGameResult(id: UUID) -> String {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "game.id == %@", id as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Player.score, ascending: false)]

        do {
            let result = try viewContext.fetch(request)
            if result.count > 0 {
                let winner = result.first
                let winnerScore = winner?.score ?? 0
                let winnerName = winner?.name ?? ""
                let winnerCount = result.filter({ $0.score == winnerScore }).count
                if winnerCount > 1 {
                    return NSLocalizedString("draw", comment: "")
                } else {
                    return "★" + winnerName
                }
            } else {
                return NSLocalizedString("noPlayers", comment: "")
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updatePlayerScore(player: Player, score: Int) {
        player.score += Int16(score)
        player.modifiedAt = Date()

        let gameRecord = Record(context: viewContext)
        gameRecord.id = UUID()
        gameRecord.timestamp = Date()
        gameRecord.value = Int16(score)
        gameRecord.player = player
        gameRecord.result = player.score
        gameRecord.game = player.game

        save()
    }

    func resetGame(game: Game) {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "game.id == %@", game.id! as CVarArg)

        do {
            let result = try viewContext.fetch(request)
            for player in result {
                updatePlayerScore(player: player, score: -Int(player.score))
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func updateGame(game: Game, name: String, icon: String, color: String) {
        game.name = name
        game.icon = icon
        game.color = color
        save()
    }

    func renamePlayer(player: Player, name: String) {
        player.name = name
        save()
    }

    func resetPlayer(player: Player) {
        updatePlayerScore(player: player, score: -Int(player.score))
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
