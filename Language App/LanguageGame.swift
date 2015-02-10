//
//  LanguageGame.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 10/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

class LanguageGame {
    
    
    //MARK: - Properties
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var managedObjectContext: NSManagedObjectContext? = nil
    var attempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("attempts")
    var correctAttempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("correctAttempts")
    
    lazy var language: Language = {
        let languageFetchRequest = NSFetchRequest()
        let languageEntity: NSEntityDescription = NSEntityDescription.entityForName("Language", inManagedObjectContext: self.managedObjectContext!)!
        let languagePredicate = NSPredicate(format: "name = %@", self.userDefaults.stringForKey("language")!)
        languageFetchRequest.entity = languageEntity
        languageFetchRequest.predicate = languagePredicate
        var error = NSErrorPointer()
        let languageRecords = self.managedObjectContext?.executeFetchRequest(languageFetchRequest, error: error) as [Language]
        return languageRecords[0]
        }()
    
//    enum streak: Printable {
//        case streak(Int)
//        
//        var description: String {
//            get {
//                return NSLocalizedString("Streak: \(self)", comment: "Navigation bar title showing the user's streak.")
//            }
//            set {
//                
//            }
//        }
//    }
    var streak: Int = 0
    var streakText: String {
        return NSLocalizedString("Streak: \(streak)", comment: "Navigation bar title showing the user's streak.")
    }

    
    //MARK: - Initialisers
    init () {
        
    }
    
    deinit {
        userDefaults.setInteger(attempts, forKey: "attempts")
        userDefaults.setInteger(correctAttempts, forKey: "correctAttempts")
    }
    
    //MARK: Functions
    func saveLongestStreak () {
        if userDefaults.integerForKey("longestStreak") < streak {
            userDefaults.setInteger(streak, forKey: "longestStreak")
        }
    }
    
    
    
}