//
//  Difficulty.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum Difficulty {
    
    case easy
    case medium
    case hard
    
    init () {
        switch (Foundation.UserDefaults.standard.string(forKey: UserDefaults.Difficulty)!) {
        case Difficulty.easy.toString():
            self = .easy
        case Difficulty.medium.toString():
            self = .medium
        case Difficulty.hard.toString():
            self = .hard
        default:
            self = .easy
        }
    }
    
    func toString () -> String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}
