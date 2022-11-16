//
//  RefreshTimer.swift
//  Stav
//
//  Created by Samuel Tóth on 10/11/2022.
//

import Foundation

class RefreshTimer: ObservableObject {
    
    public var objectWillChange = Timer.publish(every: 1, on: .main, in:.common).autoconnect()
    
}
