//
//  GameStatus.swift
//  Stav
//
//  Created by Samuel Tóth on 10/11/2022.
//

import Foundation

enum GameStatus: String, CaseIterable {
    
    case playerwin = "%@ is first"
    case draw = "Draw"
    case noplayers = "No players"
}
