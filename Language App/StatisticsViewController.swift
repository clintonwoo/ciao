//
//  StatisticsViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 20/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StatisticsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var favouriteLanguage: UILabel!
    @IBOutlet weak var wordsAttemptedLabel: UILabel!
    @IBOutlet weak var percentageCorrectLabel: UILabel!
    @IBOutlet weak var favouriteLanguageLabel: UILabel!
    @IBOutlet weak var successfulWordLabel: UILabel!
    @IBOutlet weak var unsuccessfulWordLabel: UILabel!
    @IBOutlet weak var longestStreakLabel: UILabel!
    
    //MARK: - Properties
    var game: LanguageGame!
    var model = Model()
    var coreDataDelegate: CoreDataDelegate!

    //MARK: - Initialisers    
    deinit {
        if coreDataDelegate.saveContext() {
            println("Managed Object Context save successful on StatisticsViewController deinit")
        }
    }
    
    //MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Statistics methods
    func refresh() {
        //var numberFormatter = NSNumberFormatter()
        var error: NSErrorPointer = NSErrorPointer()
        var languageFetchRequest = NSFetchRequest(entityName: "Language")
        languageFetchRequest.predicate = NSPredicate(format: "attempts = max(attempts)")
        var languages = coreDataDelegate.managedObjectContext?.executeFetchRequest(languageFetchRequest, error: error) as! [Language]
        //let sortedLanguageAttempts = languageAttempts.keysSortedByValueUsingSelector("compare:") as [String]
        var percentageCorrect: Double
        if model.attempts == 0 {
            percentageCorrect = 0
        } else {
            percentageCorrect = Double(model.correctAttempts)/Double(model.attempts) * 100
        }
        var fetchRequest = NSFetchRequest(entityName: "Word")
        let maxCorrectAttemptsPredicate = NSPredicate(format: "correctAttempts = max(correctAttempts)")
        fetchRequest.predicate = maxCorrectAttemptsPredicate
        if var fetchResult = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as? [Word] {
            println(fetchResult.description)
            if (fetchResult[0].correctAttempts == 0) {
                self.successfulWordLabel.text = NSLocalizedString("Most Successful Word:", comment: "Statistic label showing the number of words the user has attempted")
            } else {
                println("Fetchresult 0: \(fetchResult[0].word)")
                self.successfulWordLabel.text = NSLocalizedString("Most Successful Word: \(fetchResult[0].word)", comment: "Statistic label showing the number of words the user has attempted")
            }
            let maxIncorrectAttemptsPredicate = NSPredicate(format: "incorrectAttempts = max(incorrectAttempts)")
            fetchRequest.predicate = maxIncorrectAttemptsPredicate
            fetchResult = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as! [Word]
            if (fetchResult[0].incorrectAttempts == 0 ) {
                self.unsuccessfulWordLabel.text = NSLocalizedString("Most Unsuccessful Word:", comment: "Statistic label showing the number of words the user has attempted")
            } else {
                self.unsuccessfulWordLabel.text = NSLocalizedString("Most Unsuccessful Word: \(fetchResult[0].word)", comment: "Statistic label showing the number of words the user has attempted")
            }
        } else {
            println("fetch request failed")
        }
        self.wordsAttemptedLabel.text = NSLocalizedString("Words Attempted: \(model.attempts)", comment: "Statistic label showing the number of words the user has attempted")
        self.percentageCorrectLabel.text = NSLocalizedString("Correct Ratio: \(ceil(percentageCorrect))%", comment: "Statistic label showing user's ratio of correct word attempts")
        if (languages[0].attempts != 0) {
            let key = "name"
            println(languages.description)
            self.favouriteLanguage.text = NSLocalizedString("Favourite Language: \(languages[0].name)", comment: "User's favourite language")
        } else {
            self.favouriteLanguage.text = NSLocalizedString("Favourite Language:", comment: "User's favourite language")
        }
        self.longestStreakLabel.text = NSLocalizedString("Longest Streak: \(model.longestStreak)", comment: "Statistic label showing the user's longest streak")
    }
    
    private func resetStats() {
        let defaultsDictionary: Dictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("UserDefaults", ofType: "plist")!)! as Dictionary
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: UserDefaults.Attempts)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: UserDefaults.CorrectAttempts)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: UserDefaults.LongestStreak)
        var error: NSErrorPointer = NSErrorPointer()
        //go through core data and clear all attempts on Word and Language entity to 0
        var wordBatchRequest = NSBatchUpdateRequest(entityName: "Word")
        let zero = NSNumber(int: 0)
        wordBatchRequest.propertiesToUpdate = [ "incorrectAttempts": zero, "correctAttempts": zero, "attempts": zero]
        wordBatchRequest.resultType = .UpdatedObjectsCountResultType
        if var results = coreDataDelegate.managedObjectContext?.executeRequest(wordBatchRequest, error: error) {
            println("Updated \(results)")
        } else {
            println(error.debugDescription)
        }
        var languageBatchRequest = NSBatchUpdateRequest(entityName: "Language")
        languageBatchRequest.propertiesToUpdate = ["attempts": zero]
        languageBatchRequest.resultType = .UpdatedObjectsCountResultType
        if var results = coreDataDelegate.managedObjectContext?.executeRequest(languageBatchRequest, error: error) {
            println("Updated \(results)")
        } else {
            println(error.debugDescription)
        }
    }
    
    //MARK: Target action methods
    @IBAction func ResetStats(sender: UIButton) {
        resetStats()
        refresh()
//        var storyBoard: UIStoryboard = UIStoryboard(name: "SecretStoryboard", bundle: NSBundle(path: "/Users/clintondannolfo/Desktop/Language App/Language App/SecretStoryboard.storyboard"))
//        var initialViewController: UIViewController = storyBoard.instantiateInitialViewController() as UIViewController
//        self.presentViewController(initialViewController, animated: true, completion: nil)
    }
}