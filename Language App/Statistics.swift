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
    let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
    
    // MARK: - Model
    
    var attempts: Int {
        get {
            return NSNumber(longLong: iCloudStore.longLongForKey(UserDefaults.Attempts)).integerValue
//            return userDefaults.integerForKey(UserDefaults.Attempts) ?? 0
        }
        set {
//            userDefaults.setInteger(newValue, forKey: UserDefaults.Attempts)
            iCloudStore.setLongLong(Int64(newValue), forKey: UserDefaults.Attempts)
        }
    }
    var correctAttempts: Int {
        get {
            return NSNumber(longLong: iCloudStore.longLongForKey(UserDefaults.CorrectAttempts)).integerValue
        }
        set {
            iCloudStore.setLongLong(Int64(newValue), forKey: UserDefaults.CorrectAttempts)
//            userDefaults.setInteger(newValue, forKey: UserDefaults.CorrectAttempts)
        }
    }
    var longestStreak: Int {
        get {
            return NSNumber(longLong: iCloudStore.longLongForKey(UserDefaults.LongestStreak)).integerValue
//            return userDefaults.integerForKey(UserDefaults.LongestStreak)
        }
        set {
            iCloudStore.setLongLong(Int64(newValue), forKey: UserDefaults.LongestStreak)
//            userDefaults.setInteger(newValue, forKey: UserDefaults.LongestStreak)
//            NSNotificationCenter.defaultCenter().postNotificationName(<#aName: String#>, object: <#AnyObject?#>)
        }
    }
    
    // MARK: - Initialisers
    
    init () {
        
    }
}