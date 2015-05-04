//
//  StatisticsModel.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

class StatisticsModel: Statistics {
    
    // MARK: - Properties
    
    var coreDataDelegate: CoreDataDelegate!
    
    // MARK: - Model
    
    var percentageCorrect: Double {
        if attempts == 0 {
            return 0
        } else {
            return (Double(correctAttempts) / (Double(attempts))) * 100
        }
    }
    
    var favouriteLanguage: String {
        var error: NSError?
        let languageFetchRequest: NSFetchRequest! = coreDataDelegate.managedObjectModel?.fetchRequestTemplateForName("favouriteLanguage")
        let languages = coreDataDelegate.managedObjectContext?.executeFetchRequest(languageFetchRequest, error: &error) as! [Language]
        return languages[0].attempts == 0 ? "" : languages[0].name
    }
    
    var mostSuccessfulWord: String {
        var error: NSError?
//        var fetchRequest = NSFetchRequest(entityName: Entity.Word)
        let mostSuccessfulWordFetchRequest: NSFetchRequest! = coreDataDelegate.managedObjectModel?.fetchRequestTemplateForName("mostSuccessfulWord")
//        fetchRequest.predicate = NSPredicate(format: "correctAttempts = max(correctAttempts)")
        let fetchResult = coreDataDelegate.managedObjectContext?.executeFetchRequest(mostSuccessfulWordFetchRequest, error: &error) as? [Word]
//            println(fetchResult!.description)
        return fetchResult?[0].correctAttempts == 0 ? "" : fetchResult![0].word
    }
    
    var mostUnsuccessfulWord: String {
        var error: NSError?
//        var fetchRequest = NSFetchRequest(entityName: Entity.Word)
        let mostUnsuccessfulWordFetchRequest: NSFetchRequest! = coreDataDelegate.managedObjectModel?.fetchRequestTemplateForName("mostUnsuccessfulWord")
        let fetchResult = coreDataDelegate.managedObjectContext?.executeFetchRequest(mostUnsuccessfulWordFetchRequest, error: &error) as? [Word]
//        let maxIncorrectAttemptsPredicate = NSPredicate(format: "incorrectAttempts = max(incorrectAttempts)")
//        fetchRequest.predicate = maxIncorrectAttemptsPredicate
//        fetchResult = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as? [Word]
        return fetchResult![0].incorrectAttempts == 0 ? "" : fetchResult![0].word
    }
    
    // MARK: - Model Behaviours
    
    func resetStatistics () {
        let defaultsDictionary: Dictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource(ResourceName.UserDefaults.rawValue, ofType: ResourceName.UserDefaults.Type)!)! as Dictionary
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: UserDefaults.Attempts)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: UserDefaults.CorrectAttempts)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: UserDefaults.LongestStreak)
        var error: NSError?
        //go through core data and clear all attempts on Word and Language entity to 0
        var wordBatchRequest = NSBatchUpdateRequest(entityName: Entity.Word)
        let zero = NSNumber(int: 0)
        wordBatchRequest.propertiesToUpdate = [ "incorrectAttempts": zero, "correctAttempts": zero, "attempts": zero]
        wordBatchRequest.resultType = .UpdatedObjectsCountResultType
        if var results = coreDataDelegate.managedObjectContext?.executeRequest(wordBatchRequest, error: &error) {
            println("Updated \(results)")
        } else {
            println(error.debugDescription)
        }
        var languageBatchRequest = NSBatchUpdateRequest(entityName: Entity.Language)
        languageBatchRequest.propertiesToUpdate = ["attempts": zero]
        languageBatchRequest.resultType = .UpdatedObjectsCountResultType
        if var results = coreDataDelegate.managedObjectContext?.executeRequest(languageBatchRequest, error: &error) {
            println("Updated \(results)")
        } else {
            println(error.debugDescription)
        }
    }
}