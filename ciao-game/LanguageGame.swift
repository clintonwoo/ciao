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
    
    /**
    Initialises an instance of LanguageGame with a reference to Core Data Delegate set.
    
    :returns: Instance of LanguageGame.
    */
    init (delegate: CoreDataDelegate) {
        super.init()
        coreDataDelegate = delegate
    }
    
    deinit {
        saveLongestStreak()
        if coreDataDelegate.saveContext() {
            print("Managed Object Context save successful on \(self) deinit")
        }
    }

    // MARK: - Model
    
    var foreignWords: [Word] = []
    var currentLanguageRecord: Language? {
//        var error: NSError?
        let languageFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let languageEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName: Entity.Language, in: coreDataDelegate.managedObjectContext!)!
        let languagePredicate = NSPredicate(format: "name = %@", self.language)
        languageFetchRequest.entity = languageEntity
        languageFetchRequest.predicate = languagePredicate
        do {
            let languageRecords = try coreDataDelegate.managedObjectContext?.fetch(languageFetchRequest) as! [Language]
            return languageRecords[0]
        } catch {
            print(error)
            return nil
        }
    }
    var currentStreak: Int = 0
    
    //MARK: - Computed properties
    var streakText: String {
        return NSLocalizedString("Streak: \(currentStreak)", comment: "Navigation bar title showing the user's streak.")
    }
    var foreignHi: String! {
        get {
//            var error: NSError?
            let hiFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
            hiFetchRequest.predicate = NSPredicate(format: "language.name = %@ AND englishWord.word = %@", language, "Hi")
            do {
                let temp = try coreDataDelegate.managedObjectContext?.fetch(hiFetchRequest) as! [Word]
                return temp[0].word
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    //MARK: - Data Model
    internal func fetchData() {
        // In swift, pass by reference (NSErrorPointer) by using &.
//        var error: NSError?
        var difficultyPredicateString: String = ""
        switch (difficulty) {
        case .easy:
            difficultyPredicateString = "englishWord.difficulty = 'Easy'"
        case .medium:
            difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium'}"
        case .hard:
            difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium', 'Hard'}"
        }
        switch (gameMode) {
        case .introMode:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = false", currentLanguageRecord!)
            do {
                self.foreignWords = try coreDataDelegate.managedObjectContext?.fetch(fetchRequest) as! [Word]
            } catch {
                print(error)
            }
        case .grammarMode:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord!)
            do {
                self.foreignWords = try coreDataDelegate.managedObjectContext?.fetch(fetchRequest) as! [Word]
            } catch {
                print(error)
            }
        case .alphabetMode:
            print("Not fetching data. Words do not apply to alphabet mode, only letters.")
        case .phraseMode:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord!)
            do {
                self.foreignWords = try coreDataDelegate.managedObjectContext?.fetch(fetchRequest) as! [Word]
            } catch {
                print(error)
            }
        case .verbMode:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord!)
            do {
                self.foreignWords = try coreDataDelegate.managedObjectContext?.fetch(fetchRequest) as! [Word]
            } catch {
                print(error)
            }
        case .dictationMode:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", currentLanguageRecord!)
            do {
                self.foreignWords = try coreDataDelegate.managedObjectContext?.fetch(fetchRequest) as! [Word]
            } catch {
                print(error)
            }
            
        }
    }
    
    //MARK: - Functions
    func saveLongestStreak () {
        if longestStreak < currentStreak {
            longestStreak = currentStreak
        }
    }
}
