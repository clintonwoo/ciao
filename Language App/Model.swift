//
//  Defaults.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 27/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class Model {
    
    //MARK: - Properties
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var speakingSpeed: Float {
        get {
            return userDefaults.floatForKey("speakingSpeed")
        }
        set {
            userDefaults.setFloat(newValue, forKey: Defaults.SpeakingSpeed)
        }
    }

    var attempts: Int {
        get {
            return userDefaults.integerForKey(Defaults.Attempts) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: Defaults.Attempts)
        }
    }
    var correctAttempts: Int {
        get {
            return userDefaults.integerForKey(Defaults.CorrectAttempts) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: Defaults.CorrectAttempts)
        }
        //        didSet {
        //            //update() update the UI
        //            if (controller != nil) {
        //                controller?.setStreakText("")
        //            }
    }
    var longestStreak: Int {
        get {
            return userDefaults.integerForKey(Defaults.LongestStreak)
        }
        set {
            userDefaults.setInteger(newValue, forKey: Defaults.LongestStreak)
        }
    }
    var language: String {
        get {
            return userDefaults.stringForKey(Defaults.Language)!
        }
        set {
            userDefaults.setValue(newValue, forKey: Defaults.Language)
        }
    }
    var difficulty: String {
        get {
            return userDefaults.stringForKey(Defaults.Difficulty)!
        }
        set {
            userDefaults.setValue(newValue, forKey: Defaults.Difficulty)
        }
    }
    var gameMode: String {
        get {
            return userDefaults.stringForKey(Defaults.GameMode)!
        }
        set {
            userDefaults.setValue(newValue, forKey: Defaults.GameMode)
        }
    }
    
    // MARK: - Initialisers
    
    init () {
        
    }
}