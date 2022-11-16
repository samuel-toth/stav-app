//
//  StavApp.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//

import SwiftUI

@main
struct StavApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
