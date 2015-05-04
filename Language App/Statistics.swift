//
//  Statistics.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 27/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class Statistics {
    
    // MARK: - Properties
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - Model
    
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
    }
    var longestStreak: Int {
        get {
            return userDefaults.integerForKey(UserDefaults.LongestStreak)
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaults.LongestStreak)
//            NSNotificationCenter.defaultCenter().postNotificationName(<#aName: String#>, object: <#AnyObject?#>)
        }
    }
    
    // MARK: - Initialisers
    
    init () {
        
    }
}