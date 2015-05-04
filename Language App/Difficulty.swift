//
//  Difficulty.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum Difficulty {
    case Easy
    case Medium
    case Hard
    
    init () {
        switch (NSUserDefaults.standardUserDefaults().stringForKey(UserDefaults.Difficulty)!) {
        case Difficulty.Easy.toString():
            self = .Easy
        case Difficulty.Medium.toString():
            self = .Medium
        case Difficulty.Hard.toString():
            self = .Hard
        default:
            self = .Easy
        }
    }
    
    func toString () -> String {
        switch self {
        case Easy:
            return "Easy"
        case Medium:
            return "Medium"
        case Hard:
            return "Hard"
        }
    }
}