//
//  Persistence.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<3 {
            let newCounter = Counter(context: viewContext)
            newCounter.id = UUID()
            newCounter.name = "Test"
            newCounter.value = 0
            newCounter.createdAt = Date()
            newCounter.modifiedAt = Date()
            newCounter.hasGoal = true
            newCounter.value = 200
            newCounter.goalDate = Date().addingTimeInterval(100000)
            newCounter.isFavourite = i < 2 ? false : true

            let newGame = Game(context: viewContext)
            newGame.id = UUID()
            newGame.name = "NHL"
            newGame.color = "picker_blue"
            newGame.createdAt = Date()
        }
        
        try! viewContext.save()
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Stav")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
