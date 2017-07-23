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
    
    var favouriteLanguage: String? {
        
        let languageFetchRequest: NSFetchRequest! = coreDataDelegate.managedObjectModel?.fetchRequestTemplate(forName: "favouriteLanguage")
        do {
            let languages = try coreDataDelegate.managedObjectContext!.fetch(languageFetchRequest) as! [Language]
            return languages[0].attempts == 0 ? "" : languages[0].name
        } catch {
            print(error)
            return nil
        }
    }
    
    var mostSuccessfulWord: String? {
        let mostSuccessfulWordFetchRequest: NSFetchRequest! = coreDataDelegate.managedObjectModel?.fetchRequestTemplate(forName: "mostSuccessfulWord")
        do {
            let fetchResult = try coreDataDelegate.managedObjectContext!.fetch(mostSuccessfulWordFetchRequest) as? [Word]
            return fetchResult?[0].correctAttempts == 0 ? "" : fetchResult![0].word
        } catch {
            print(error)
            return nil
        }
    }
    
    var mostUnsuccessfulWord: String? {
        let mostUnsuccessfulWordFetchRequest: NSFetchRequest! = coreDataDelegate.managedObjectModel?.fetchRequestTemplate(forName: "mostUnsuccessfulWord")
        do {
            let fetchResult = try coreDataDelegate.managedObjectContext!.fetch(mostUnsuccessfulWordFetchRequest) as? [Word]
            return fetchResult![0].incorrectAttempts == 0 ? "" : fetchResult![0].word
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - Model Behaviours
    
    func resetStatistics () {
        attempts = 0
        correctAttempts = 0
        longestStreak = 0
        //go through core data and clear all attempts on Word and Language entity to 0
        let wordBatchRequest = NSBatchUpdateRequest(entityName: Entity.Word)
        let zero = NSNumber(value: 0 as Int32)
        wordBatchRequest.propertiesToUpdate = [ "incorrectAttempts": zero, "correctAttempts": zero, "attempts": zero]
        wordBatchRequest.resultType = .updatedObjectsCountResultType
        do {
            let results = try coreDataDelegate.managedObjectContext?.execute(wordBatchRequest)
            print("Updated \(String(describing: results))")
        } catch {
            print(error)
        }
        let languageBatchRequest = NSBatchUpdateRequest(entityName: Entity.Language)
        languageBatchRequest.propertiesToUpdate = ["attempts": zero]
        languageBatchRequest.resultType = .updatedObjectsCountResultType
        do {
            let results = try coreDataDelegate.managedObjectContext?.execute(languageBatchRequest)
        } catch {
            print(error)
        }
    }
}
