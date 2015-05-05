//
//  UserDefaults.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 27/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class Model: Statistics {
    
    //MARK: - Model
    
    var speakingSpeed: Float {
        get {
            return userDefaults.floatForKey(UserDefaults.SpeakingSpeed)
        }
        set {
            userDefaults.setFloat(newValue, forKey: UserDefaults.SpeakingSpeed)
        }
    }

    var language: String {
        get {
            return userDefaults.stringForKey(UserDefaults.Language)!
        }
        set {
            userDefaults.setValue(newValue, forKey: UserDefaults.Language)
        }
    }
    
    var difficulty: Difficulty = Difficulty() {
        didSet {
            userDefaults.setValue(difficulty.toString(), forKey: UserDefaults.Difficulty)
        }
    }

    var gameMode: GameMode = GameMode() {
        didSet {
            userDefaults.setValue(gameMode.rawValue, forKey: UserDefaults.GameMode)
        }
    }
    
    // MARK: - Initialisers
    
    override init () {
        
    }
}