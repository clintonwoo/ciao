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
    
    //MARK: Outlets
    @IBOutlet weak var favouriteLanguage: UILabel!
    @IBOutlet weak var wordsAttemptedLabel: UILabel!
    @IBOutlet weak var percentageCorrectLabel: UILabel!
    @IBOutlet weak var favouriteLanguageLabel: UILabel!
    @IBOutlet weak var successfulWordLabel: UILabel!
    @IBOutlet weak var unsuccessfulWordLabel: UILabel!
    @IBOutlet weak var longestStreakLabel: UILabel!
    
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext? = nil
    var userDefaults = NSUserDefaults.standardUserDefaults()

    //MARK: Initialisers
    override init() {
        super.init()
    }
    
    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        var error: NSErrorPointer = NSErrorPointer()
        if (managedObjectContext?.save(error) == nil) {
            println("Error: \(error.debugDescription)")
        } else {
            println("Managed Object Context save successful on StatisticsViewController deinit")
        }
    }
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refresh() {
        var numberFormatter = NSNumberFormatter()
        //numberFormatter
        var languageAttempts: NSDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey("languageAttempts")!
        println(languageAttempts.description)
        let sortedLanguageAttempts = languageAttempts.keysSortedByValueUsingSelector("compare:") as [String]
        let reverseArray = sortedLanguageAttempts.reverse()
        println(sortedLanguageAttempts.description)
        
        let streak = String(userDefaults.integerForKey("longestStreak"))
        let attempts = userDefaults.integerForKey("attempts")
        let correctAttempts = userDefaults.integerForKey("correctAttempts")
        var percentageCorrect: Double
        if attempts == 0 {
            percentageCorrect = 0
        } else {
            percentageCorrect = Double(correctAttempts)/Double(attempts) * 100
        }
        var fetchRequest = NSFetchRequest()
        let entity: NSEntityDescription = NSEntityDescription.entityForName("Word", inManagedObjectContext: self.managedObjectContext!)!
        let maxCorrectAttemptsPredicate = NSPredicate(format: "correctAttempts = max(correctAttempts)")
        fetchRequest.entity = entity
        fetchRequest.predicate = maxCorrectAttemptsPredicate
        var error: NSErrorPointer = NSErrorPointer()
        if var fetchResult = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as? [Word] {
            println(fetchResult.description)
            println(fetchResult[0].description)
            if (fetchResult[0].correctAttempts == 0) {
                self.successfulWordLabel.text = NSLocalizedString("Most Successful Word:", comment: "Statistic label showing the number of words the user has attempted")
            } else {
                self.successfulWordLabel.text = NSLocalizedString("Most Successful Word: \(fetchResult[0].word)", comment: "Statistic label showing the number of words the user has attempted")
            }
            let maxIncorrectAttemptsPredicate = NSPredicate(format: "incorrectAttempts = max(incorrectAttempts)")
            fetchRequest.predicate = maxIncorrectAttemptsPredicate
            //        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "attempts", ascending: true)
            fetchResult = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
            if (fetchResult[0].incorrectAttempts == 0 ) {
                self.unsuccessfulWordLabel.text = NSLocalizedString("Most Unsuccessful Word:", comment: "Statistic label showing the number of words the user has attempted")
            } else {
                self.unsuccessfulWordLabel.text = NSLocalizedString("Most Unsuccessful Word: \(fetchResult[0].word)", comment: "Statistic label showing the number of words the user has attempted")
            }
        } else {
            println("fetch request failed")
        }
        self.wordsAttemptedLabel.text = NSLocalizedString("Words Attempted: \(attempts)", comment: "Statistic label showing the number of words the user has attempted")
        self.percentageCorrectLabel.text = NSLocalizedString("Correct Ratio: \(ceil(percentageCorrect))%", comment: "Statistic label showing user's ratio of correct word attempts")
        if languageAttempts.valueForKey(reverseArray[0]) as NSNumber != 0 {
            self.favouriteLanguage.text = NSLocalizedString("Favourite Language: \(reverseArray[0])", comment: "User's favourite language")
        } else {
            self.favouriteLanguage.text = NSLocalizedString("Favourite Language:", comment: "User's favourite language")
        }
        self.longestStreakLabel.text = NSLocalizedString("Longest Streak: \(streak)", comment: "Statistic label showing the user's longest streak")
    }
    
    override func viewWillAppear(animated: Bool) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Statistics methods
    @IBAction func ResetStats(sender: UIButton) {
        let defaultsPlistPath: String = NSBundle.mainBundle().pathForResource("Defaults", ofType:"plist")!
        let defaultsDictionary: NSDictionary = NSDictionary(contentsOfFile: defaultsPlistPath)!
        userDefaults.setInteger(0, forKey: "attempts")
        userDefaults.setInteger(0, forKey: "correctAttempts")
        userDefaults.setInteger(0, forKey: "longestStreak")
        userDefaults.setObject(defaultsDictionary.valueForKey("languageAttempts"), forKey: "languageAttempts")
        //go through core data and clear all attempts etc to 0
        var error: NSErrorPointer = NSErrorPointer()
        var batchRequest = NSBatchUpdateRequest(entityName: "Word")
        let zero = NSNumber(int: 0)
        batchRequest.propertiesToUpdate = [ "incorrectAttempts": zero, "correctAttempts": zero, "attempts": zero]
        batchRequest.resultType = .UpdatedObjectsCountResultType
        if var results = managedObjectContext?.executeRequest(batchRequest, error: error) {
            println("Updated \(results)")
        } else {
            println(error.debugDescription)
        }
//        var fetchRequest = NSFetchRequest()
//        let entity: NSEntityDescription = NSEntityDescription.entityForName("Word", inManagedObjectContext: self.managedObjectContext!)!
//        fetchRequest.entity = entity
//        if var fetchResult: [Word] = managedObjectContext?.executeFetchRequest(fetchRequest, error: error)! as? [Word] {
//            for word in fetchResult {
//                let zero = NSNumber(int: 0)
//                word.incorrectAttempts = zero
//                word.correctAttempts = zero
//                word.attempts = zero
//            }
//        } else {
//            println("reset stats fetch request failed")
//        }
    //        if managedObjectContext?.save(error) != nil {
    //            println("reset stats managed object context save successful")
    //        } else {
    //            println(error.debugDescription)
    //        }
        refresh()
//        var storyBoard: UIStoryboard = UIStoryboard(name: "SecretStoryboard", bundle: NSBundle(path: "/Users/clintondannolfo/Desktop/Language App/Language App/SecretStoryboard.storyboard"))
//        var initialViewController: UIViewController = storyBoard.instantiateInitialViewController() as UIViewController
//        self.presentViewController(initialViewController, animated: true, completion: nil)
    }
}