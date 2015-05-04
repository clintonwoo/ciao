//
//  ViewController.swift
//  Language App
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
    @IBOutlet weak var gameButton1: GameButton! {
        didSet {
            gameButton1.dataSource = self
        }
    }
    @IBOutlet weak var gameButton2: UIButton!
    @IBOutlet weak var gameButton3: UIButton!
    @IBOutlet weak var gameButton4: UIButton!
    
    //MARK: - Properties
    var wordNumbers: [Int] = [0,0,0,0]
    
    //MARK: - Initialisers
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setStreakText()
        
        //set label to language's hi
        wordLabel.text = game.foreignHi
//        var adView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
//        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait
//        self.view.addSubview(adView)
        // Do any additional setup after loading the view, typically from a nib.
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
    
    internal func endStreak () {
        game.saveLongestStreak()
        game.currentStreak = 0
        setStreakText()
    }
    
    func setStreakText () {
        self.navigationItem.title = game.streakText
    }
    
    //MARK: - Target action methods
    @IBAction func clickGameButton(sender: GameButton) {
        game.attempts += 1
        //create a new NSNumber to increment managed objects
        var convertingNumber: NSNumber
        convertingNumber = NSNumber(int: game.currentLanguageRecord.attempts.intValue + 1)
        game.currentLanguageRecord.attempts = convertingNumber
        if wordNumbers != [0,0,0,0] {
            convertingNumber = NSNumber(int: game.foreignWords[wordNumbers[sender.gameButtonIndex]].attempts.intValue + 1)
            game.foreignWords[wordNumbers[sender.gameButtonIndex]].attempts = convertingNumber
        }
        if (sender.correct) {
            if sender.currentTitle == nil {
                sayWord(wordLabel.text!, localWord: sender.currentAttributedTitle?.string)
            } else {
            sayWord(wordLabel.text!, localWord: sender.currentTitle!)
            }
            if wordNumbers != [0,0,0,0] {
                convertingNumber = NSNumber(int: game.foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts.intValue + 1)
                game.foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts = convertingNumber
            }
            game.currentStreak += 1
            game.correctAttempts += 1
            game.saveLongestStreak()
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            convertingNumber = NSNumber(int: game.foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts.intValue + 1)
            game.foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts = convertingNumber
            endStreak()
        }
    }
    
    //MARK: - GameButton View
    func getIntegerData(sender: GameButton) -> Int {
        return 0
    }
}

