//
//  ContentView.swift
//  Stav
//
//  Created by Samuel Tóth on 02/11/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
    }
    var body: some View {
        TabView {
            CounterList().environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("counters", systemImage: "number")
                        .fontWeight(.heavy)
                }
            GameList().environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("games", systemImage: "person.3.fill")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environment(\.locale, .init(identifier: "sk"))

    }
}
