//
//  CounterManager.swift
//  Stav
//
//  Created by Samuel Tóth on 10/11/2022.
//

import Foundation
import CoreData

class CounterManager {
    
    static let shared = CounterManager()
    
    private var viewContext = PersistenceController.shared.container.viewContext
    
    func addCounter(name: String, value: Int, hasGoal: Bool, color: String, icon: String, goalValue: Int?, goalDate: Date?) {
        let newCounter = Counter(context: viewContext)
        newCounter.id = UUID()
        newCounter.createdAt = Date()
        newCounter.modifiedAt = Date()
        newCounter.isFavourite = false

        newCounter.name = name
        newCounter.value = Int16(value)
        newCounter.hasGoal = hasGoal
        newCounter.color = color
        newCounter.icon = icon
        if hasGoal {
            newCounter.goalValue = Int16(goalValue ?? 0)
            newCounter.goalDate = goalDate
        }
        
        let historyRecord = CounterHistoryRecord(context: viewContext)
        historyRecord.id = UUID()
        historyRecord.timestamp = Date()
        historyRecord.value = Int16(value)
        historyRecord.recordCounter = newCounter
        historyRecord.result = Int16(value)
        
        save()
    }

    func updateCounterValue(counter: Counter, value: Int) {
        counter.value += Int16(value)
        counter.modifiedAt = Date()

        let historyRecord = CounterHistoryRecord(context: viewContext)
        historyRecord.id = UUID()
        historyRecord.timestamp = Date()
        historyRecord.value = Int16(value)
        historyRecord.recordCounter = counter
        historyRecord.result = counter.value
        
        save()
    }
    
    func updateCounter(counter: Counter, name: String, hasGoal: Bool, color: String, icon: String, goalValue: Int, goalDate: Date) {
        counter.name = name
        counter.modifiedAt = Date()
        counter.hasGoal = hasGoal
        counter.color = color
        counter.icon = icon
        if hasGoal {
            counter.goalValue = Int16(goalValue)
            counter.goalDate = goalDate
        }
        
        save()
    }

    func deleteCounter(counter: Counter) {
        viewContext.delete(counter)
        
        save()
    }
    
    func toggleFavourite(counter: Counter) {
        counter.isFavourite.toggle()
        
        save()
    }
    
    func resetCounter(counter: Counter) {
        let historyRecord = CounterHistoryRecord(context: viewContext)
        historyRecord.id = UUID()
        historyRecord.timestamp = Date()
        historyRecord.value = Int16(0 - counter.value)
        historyRecord.recordCounter = counter
        
        counter.value = 0
        counter.modifiedAt = Date()
        
        historyRecord.result = counter.value
        
        save()
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
    //private var previewViewContext = PersistenceController.preview.container.viewContext

    func createTestData() -> Counter {
        let newCounter = Counter(context: viewContext)
        newCounter.id = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        newCounter.createdAt = Date().addingTimeInterval(-100000)
        newCounter.modifiedAt = Date().addingTimeInterval(-1000)
        newCounter.isFavourite = false

        newCounter.name = "Test Counter"
        newCounter.value = 0
        newCounter.hasGoal = true
        newCounter.goalValue = 30
        newCounter.goalDate = Date().addingTimeInterval(86400 * 30)
        newCounter.color = "picker_red"
        newCounter.icon = "car.circle.fill"

        // create 100 history records from 100 days ago to today with random values
        for i in 0...100 {
            let historyRecord = CounterHistoryRecord(context: viewContext)
            historyRecord.id = UUID()
            historyRecord.timestamp = Date().addingTimeInterval(Double(-100000 + i * 86400))
            historyRecord.value = Int16.random(in: -10...10)
            historyRecord.recordCounter = newCounter
            historyRecord.result = Int16.random(in: 200...400)
        }



        do {
            try viewContext.save()
            return newCounter
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
