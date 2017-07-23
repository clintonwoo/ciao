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
    
    let userDefaults = Foundation.UserDefaults.standard
    let iCloudStore = NSUbiquitousKeyValueStore.default()
    
    // MARK: - Model
    
    var attempts: Int {
        get {
            return NSNumber(value: iCloudStore.longLong(forKey: UserDefaults.Attempts) as Int64).intValue
//            return userDefaults.integerForKey(UserDefaults.Attempts) ?? 0
        }
        set {
//            userDefaults.setInteger(newValue, forKey: UserDefaults.Attempts)
            iCloudStore.set(Int64(newValue), forKey: UserDefaults.Attempts)
        }
    }
    var correctAttempts: Int {
        get {
            return NSNumber(value: iCloudStore.longLong(forKey: UserDefaults.CorrectAttempts) as Int64).intValue
        }
        set {
            iCloudStore.set(Int64(newValue), forKey: UserDefaults.CorrectAttempts)
//            userDefaults.setInteger(newValue, forKey: UserDefaults.CorrectAttempts)
        }
    }
    var longestStreak: Int {
        get {
            return NSNumber(value: iCloudStore.longLong(forKey: UserDefaults.LongestStreak) as Int64).intValue
//            return userDefaults.integerForKey(UserDefaults.LongestStreak)
        }
        set {
            iCloudStore.set(Int64(newValue), forKey: UserDefaults.LongestStreak)
//            userDefaults.setInteger(newValue, forKey: UserDefaults.LongestStreak)
//            NSNotificationCenter.defaultCenter().postNotificationName(<#aName: String#>, object: <#AnyObject?#>)
        }
    }
    
    // MARK: - Initialisers
    
    init () {
        
    }
}
