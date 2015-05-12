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
//    var game: LanguageGame!
    var statisticsModel = StatisticsModel()
    var coreDataDelegate: CoreDataDelegate! {
        didSet {
            statisticsModel.coreDataDelegate = coreDataDelegate
        }
    }

    //MARK: - Initialisers    
    deinit {
        if coreDataDelegate.saveContext() {
            println("Managed Object Context save successful on StatisticsViewController deinit")
        }
    }
    
    //MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localization.Title.Statistics
        loadStatistics()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Statistics methods
    func loadStatistics() {
        self.wordsAttemptedLabel.text = "\(Localization.Statistics.WordsAttempted) \(statisticsModel.attempts)"
        self.percentageCorrectLabel.text = "\(Localization.Statistics.CorrectRatio) \(ceil(statisticsModel.percentageCorrect))%"
        self.favouriteLanguage.text = "\(Localization.Statistics.FavouriteLanguage) \(statisticsModel.favouriteLanguage)"
        self.successfulWordLabel.text = "\(Localization.Statistics.MostSuccessfulWord) \(statisticsModel.mostSuccessfulWord)"
        self.unsuccessfulWordLabel.text = "\(Localization.Statistics.MostUnsuccessfulWord) \(statisticsModel.mostUnsuccessfulWord)"
        self.longestStreakLabel.text = "\(Localization.Statistics.LongestStreak) \(statisticsModel.longestStreak)"
    }
    
    //MARK: Target action methods
    @IBAction func tapResetStatisticsButton(sender: UIButton) {
        statisticsModel.resetStatistics()
        loadStatistics()
        NSUbiquitousKeyValueStore.defaultStore().synchronize()
    }
}