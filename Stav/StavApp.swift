//
//  StavApp.swift
//  Stav
//
//  Created by Samuel Tóth on 16/11/2022.
//

import SwiftUI
import SwiftData

@main
struct StavApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Counter.self, HistoryRecord.self, Player.self, Game.self, Datum.self])

    }
}
