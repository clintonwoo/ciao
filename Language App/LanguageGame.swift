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
    func setHasSound (hasSound: Bool)
}

struct Defaults {
    static let Attempts = "attempts"
    static let CorrectAttempts = "corectAttempts"
    static let Language = "language"
    static let Languages = "languages"
    static let Difficulty = "difficulty"
    static let GameMode = "gameMode"
    static let LongestStreak = "longestStreak"
    static let HasSound = "hasSound"
    static let SpeakingSpeed = "speakingSpeed"
}

struct Entity {
    static let Language = "language"
}

class LanguageGame: Model {
    
    //MARK: - Data Model Protocol
    var controller: LanguageGameModelDelegate? = nil
    
    //MARK: - Properties
    var managedObjectContext: NSManagedObjectContext
    
    override var hasSound: Bool {
        get {
            return userDefaults.boolForKey(Defaults.HasSound)
        }
        set {
            userDefaults.setBool(newValue, forKey: Defaults.HasSound)
            controller?.setHasSound(newValue)
        }
    }
    
    var foreignWords: [Word] = []
    var currentLanguageRecord: Language {
        let languageFetchRequest = NSFetchRequest()
        let languageEntity: NSEntityDescription = NSEntityDescription.entityForName("Language", inManagedObjectContext: self.managedObjectContext)!
        let languagePredicate = NSPredicate(format: "name = %@", self.language)
        languageFetchRequest.entity = languageEntity
        languageFetchRequest.predicate = languagePredicate
        var error = NSErrorPointer()
        let languageRecords = self.managedObjectContext.executeFetchRequest(languageFetchRequest, error: error) as! [Language]
        return languageRecords[0]
    }
    var currentStreak: Int = 0
    
    //MARK: - Computed properties
    var streakText: String {
        return NSLocalizedString("Streak: \(currentStreak)", comment: "Navigation bar title showing the user's streak.")
    }
    var foreignHi: String {
        get {
            let hiFetchRequest = NSFetchRequest(entityName: "Word")
            hiFetchRequest.predicate = NSPredicate(format: "language.name = %@ AND englishWord.word = %@", language, "Hi")
            var error = NSErrorPointer()
            let temp = managedObjectContext.executeFetchRequest(hiFetchRequest, error: error) as! [Word]
            return temp[0].word
        }
    }
    
    //MARK: - Initialisers
    init (context: NSManagedObjectContext) {
        managedObjectContext = context
        super.init()
//        var error = NSErrorPointer()
//        fetchData(error)
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
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as! [Word]
        case "Phrase Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as! [Word]
        case "Grammar Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as! [Word]
        case "Verb Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as! [Word]
        case "Dictation Mode":
            var fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = managedObjectContext.executeFetchRequest(fetchRequest, error: error) as! [Word]
        default:
            break
        }
    }
    
    //MARK: - Functions
    func saveLongestStreak () {
        if longestStreak < currentStreak {
            longestStreak = currentStreak
        }
    }
}