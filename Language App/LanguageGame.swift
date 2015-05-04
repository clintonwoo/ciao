//
//  LanguageGame.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 10/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

class LanguageGame: Model {
    
    //MARK: - Properties
    
    var coreDataDelegate: CoreDataDelegate!
    
    //MARK: - Initialisers
    
    init (delegate: CoreDataDelegate) {
        super.init()
        coreDataDelegate = delegate
        //        var error = NSErrorPointer()
        //        fetchData(error)
    }
    
    deinit {
        saveLongestStreak()
        if coreDataDelegate.saveContext() {
            println("Managed Object Context save successful on \(self) deinit")
        }
    }

    // MARK: - Model
    
    var foreignWords: [Word] = []
    var currentLanguageRecord: Language {
        let languageFetchRequest = NSFetchRequest()
        let languageEntity: NSEntityDescription = NSEntityDescription.entityForName(Entity.Language, inManagedObjectContext: coreDataDelegate.managedObjectContext!)!
        let languagePredicate = NSPredicate(format: "name = %@", self.language)
        languageFetchRequest.entity = languageEntity
        languageFetchRequest.predicate = languagePredicate
        var error = NSErrorPointer()
        let languageRecords = coreDataDelegate.managedObjectContext?.executeFetchRequest(languageFetchRequest, error: error) as! [Language]
        return languageRecords[0]
    }
    var currentStreak: Int = 0
    
    //MARK: - Computed properties
    var streakText: String {
        return NSLocalizedString("Streak: \(currentStreak)", comment: "Navigation bar title showing the user's streak.")
    }
    var foreignHi: String {
        get {
            let hiFetchRequest = NSFetchRequest(entityName: Entity.Word)
            hiFetchRequest.predicate = NSPredicate(format: "language.name = %@ AND englishWord.word = %@", language, "Hi")
            var error = NSErrorPointer()
            let temp = coreDataDelegate.managedObjectContext?.executeFetchRequest(hiFetchRequest, error: error) as! [Word]
            return temp[0].word
        }
    }
    
    //MARK: - Data Model
    internal func fetchData() {
        // In swift, pass by reference (NSErrorPointer) by using &.
        var error: NSError?
        var difficultyPredicateString: String = ""
        switch (difficulty) {
        case .Easy:
            difficultyPredicateString = "englishWord.difficulty = 'Easy'"
        case .Medium:
            difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium'}"
        case .Hard:
            difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium', 'Hard'}"
        }
        switch (gameMode) {
        case .IntroMode:
            let fetchRequest = NSFetchRequest(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = false", currentLanguageRecord)
            self.foreignWords = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [Word]
        case .GrammarMode:
            let fetchRequest = NSFetchRequest(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [Word]
        case .AlphabetMode:
            println("Not fetching data. Words do not apply to alphabet mode, only letters.")
        case .PhraseMode:
            let fetchRequest = NSFetchRequest(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [Word]
        case .VerbMode:
            let fetchRequest = NSFetchRequest(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [Word]
        case .DictationMode:
            var fetchRequest = NSFetchRequest(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord)
            self.foreignWords = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [Word]
        }
    }
    
    //MARK: - Functions
    func saveLongestStreak () {
        if longestStreak < currentStreak {
            longestStreak = currentStreak
        }
    }
}