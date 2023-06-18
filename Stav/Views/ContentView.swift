//
//  ContentView.swift
//  Stav
//
//  Created by Samuel Tóth on 02/11/2022.
//

import SwiftUI
import CoreData
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
    }
    var body: some View {
        TabView {
            CounterList()
                .tabItem {
                    Label("counters", systemImage: "number")
                        .fontWeight(.heavy)
                }
            DateList()
                    .tabItem {
                        Label("dates", systemImage: "calendar")
                    }
            GameList()
                .tabItem {
                    Label("games", systemImage: "person.3.fill")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
