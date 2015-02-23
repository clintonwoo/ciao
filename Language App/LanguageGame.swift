//
//  LanguageGame.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 10/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

protocol LanguageGameModelDelegate {
    func setStreakText (text: String)
}

struct Defaults {
    static let Attempts = "attempts"
    static let CorrectAttempts = "corectAttempts"
    static let Language = "language"
    static let Difficulty = "difficulty"
    static let GameMode = "gameMode"
    static let LongestStreak = "longestStreak"
//    static var LongestStreak: String {
//        get {
//            return NSUserDefaults.standardUserDefaults().stringForKey(Defaults.Difficulty)!
//        }
//        set {
//            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "longestStreak")
//        }
//    }
}

struct Entity {
    static let Language = "language"
}

class LanguageGame {
    
    //MARK: - Data Model Protocol
    var controller: LanguageGameModelDelegate? = nil
    
    //MARK: - Properties
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var managedObjectContext: NSManagedObjectContext
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
    var foreignWords: [Word] = []
    lazy var currentLanguageRecord: Language = {
        let languageFetchRequest = NSFetchRequest()
        let languageEntity: NSEntityDescription = NSEntityDescription.entityForName("Language", inManagedObjectContext: self.managedObjectContext)!
        let languagePredicate = NSPredicate(format: "name = %@", self.userDefaults.stringForKey(Defaults.Language)!)
        languageFetchRequest.entity = languageEntity
        languageFetchRequest.predicate = languagePredicate
        var error = NSErrorPointer()
        let languageRecords = self.managedObjectContext.executeFetchRequest(languageFetchRequest, error: error) as [Language]
        return languageRecords[0]
        }()
    var streak: Int = 0
    
    //MARK: - Computed properties
    var streakText: String {
        return NSLocalizedString("Streak: \(streak)", comment: "Navigation bar title showing the user's streak.")
    }
    var foreignHi: String {
        get {
            let hiFetchRequest = NSFetchRequest(entityName: "Word")
            hiFetchRequest.predicate = NSPredicate(format: "language.name = %@ AND englishWord.word = %@", userDefaults.stringForKey(Defaults.Language)!, "Hi")
            var error = NSErrorPointer()
            let temp = managedObjectContext.executeFetchRequest(hiFetchRequest, error: error) as [Word]
            return temp[0].word
        }
    }
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
//    var test: String = "" {
////        get {
//                //HTTP GET
////            return ""
////        }
////        set {
//        //HTTP POST
////            
////        }
//        didSet{
//            //
//        }
//        willSet{
//            
//        }
//    }
    
    //MARK: - Initialisers
    init (context: NSManagedObjectContext) {
        managedObjectContext = context
        var error = NSErrorPointer()
        fetchData(error)
    }
    
    deinit {
//        userDefaults.setInteger(correctAttempts, forKey: Defaults.CorrectAttempts)
        saveLongestStreak()
        var error: NSErrorPointer = NSErrorPointer()
        if (managedObjectContext.save(error) == false) {
            println("Error: \(error.debugDescription)")
        } else {
            println("Managed Object Context save successful on \(self) deinit")
        }
    }
    
    //MARK: - Data Model
    internal func fetchData(error: NSErrorPointer) {
        var difficultyPredicateString: String = ""
        switch (difficulty) {
        case "Easy":
            difficultyPredicateString = "englishWord.difficulty = 'Easy'"
        case "Medium":
            difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium'}"
        case "Hard":
            difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium', 'Hard'}"
        default: abort()
        }
        switch (gameMode) {
        case "Intro Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = false", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Phrase Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Grammar Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Verb Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Dictation Mode":
            var fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as [Word]
        default:
            break
        }
    }
    
    //MARK: - Functions
    func saveLongestStreak () {
        if longestStreak < streak {
            longestStreak = streak
        }
    }
}