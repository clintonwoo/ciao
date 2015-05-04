//
//  UserDefaults.swift
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
            userDefaults.setFloat(newValue, forKey: UserDefaults.SpeakingSpeed)
        }
    }

    var attempts: Int {
        get {
            return userDefaults.integerForKey(UserDefaults.Attempts) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaults.Attempts)
        }
    }
    var correctAttempts: Int {
        get {
            return userDefaults.integerForKey(UserDefaults.CorrectAttempts) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaults.CorrectAttempts)
        }
        //        didSet {
        //            //update() update the UI
        //            if (controller != nil) {
        //                controller?.setStreakText("")
        //            }
    }
    var longestStreak: Int {
        get {
            return userDefaults.integerForKey(UserDefaults.LongestStreak)
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaults.LongestStreak)
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
    var difficulty: String {
        get {
            return userDefaults.stringForKey(UserDefaults.Difficulty)!
        }
        set {
            userDefaults.setValue(newValue, forKey: UserDefaults.Difficulty)
        }
    }
    var gameMode: String {
        get {
            return userDefaults.stringForKey(UserDefaults.GameMode)!
        }
        set {
            userDefaults.setValue(newValue, forKey: UserDefaults.GameMode)
        }
    }
    
    // MARK: - Initialisers
    
    init () {
        
    }
}