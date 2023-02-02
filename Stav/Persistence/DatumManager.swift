//
//  DatumManager.swift
//  Stav
//
//  Created by Samuel Tóth on 24/11/2022.
//

import Foundation
import CoreData

class DatumManager {
    
    static let shared = DatumManager()
    
    private var viewContext = PersistenceController.shared.container.viewContext
    
    func addDatum(name: String, icon: String, color: String, timestamp: Date){
        let newDatum = Datum(context: viewContext)
        newDatum.id = UUID()
        newDatum.name = name
        newDatum.createdAt = Date()
        newDatum.color = color
        newDatum.icon = icon
        newDatum.timestamp = timestamp

        
        save()
    }
    
    func getDatum(id: UUID) -> Datum? {
        let request: NSFetchRequest<Datum> = Datum.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteDatum(datum: Datum) {
        viewContext.delete(datum)
        save()
    }
    
    func updateDatum(datum: Datum, name: String, icon: String, color: String, timestamp: Date) {
        datum.name = name
        datum.icon = icon
        datum.color = color
        datum.timestamp = timestamp
        save()
    }
    
    func toggleFavourite(datum: Datum) {
        datum.isFavourite.toggle()
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
}
