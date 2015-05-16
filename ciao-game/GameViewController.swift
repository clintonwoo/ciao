//
//  ViewController.swift
//  ciao-game
//
//  Created by Clinton D'Annolfo on 6/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import iAd

class GameViewController: GameMasterViewController, GameButtonDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var gameButton1: GameButton!
    @IBOutlet weak var gameButton2: GameButton!
    @IBOutlet weak var gameButton3: GameButton!
    @IBOutlet weak var gameButton4: GameButton!
    
    //MARK: - Properties
    var wordNumbers: [Int] = [0,0,0,0]
    var firstAttempt = true
    
    //MARK: - Initialisers
    
    //MARK: - View controller methods
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        setStreakText()
        
        //set label to language's hi
        wordLabel.text = game.foreignHi
    }
    
    //MARK: - Game methods
    internal func refreshGame () {
        var index = 0
        do {
            wordNumbers[index] = Int(arc4random_uniform(UInt32(game.foreignWords.count)))
            if (index == 0) {
                index += 1
            } else if (!contains(wordNumbers[0..<index], wordNumbers[index])) {
                index += 1
            }
        } while (index < 4)
        let correctButtonIndex = Int(arc4random_uniform(4))
        for gameButton in gameButtonCollection {
            if gameButton.gameButtonIndex == correctButtonIndex {
                gameButton.correct = true
                gameButton.setTitle(game.foreignWords[wordNumbers[gameButton.gameButtonIndex]].englishWord.word, forState: UIControlState.Normal)
                wordLabel.text = game.foreignWords[wordNumbers[gameButton.gameButtonIndex]].word
            } else {
                gameButton.correct = false
                gameButton.setTitle(game.foreignWords[wordNumbers[gameButton.gameButtonIndex]].englishWord.word, forState: UIControlState.Normal)
            }
            UIView.animateWithDuration(0.25, animations: {gameButton.alpha = 1})
        }
        setStreakText()
    }
    
    func setStreakText () {
        self.navigationItem.title = game.streakText
    }
    
    //MARK: - Target action methods
    @IBAction func clickGameButton(sender: GameButton) {
        game.attempts += 1
        //create a new NSNumber to increment managed objects
        game.currentLanguageRecord.attempts = NSNumber(int: game.currentLanguageRecord.attempts.intValue + 1)
        if !firstAttempt {
            game.foreignWords[wordNumbers[sender.gameButtonIndex]].attempts = NSNumber(int: game.foreignWords[wordNumbers[sender.gameButtonIndex]].attempts.intValue + 1)
        }
        if (sender.correct) {
            // Attributed strings instead of normal title
            if sender.currentTitle == nil {
                sayWord(wordLabel.text!, localWord: sender.currentAttributedTitle?.string)
            } else {
                sayWord(wordLabel.text!, localWord: sender.currentTitle!)
            }
            if !firstAttempt {
                game.foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts = NSNumber(int: game.foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts.intValue + 1)
            }
            game.currentStreak += 1
            game.correctAttempts += 1
            game.saveLongestStreak()
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            game.foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts = NSNumber(int: game.foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts.intValue + 1)
            game.saveLongestStreak()
            game.currentStreak = 0
            setStreakText()
        }
        firstAttempt = false
    }
    
    //MARK: - GameButton View
    func getIntegerData(sender: GameButton) -> Int {
        return 0
    }
}

