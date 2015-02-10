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

class GameViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var gameButton1: UIButton!
    @IBOutlet weak var gameButton2: UIButton!
    @IBOutlet weak var gameButton3: UIButton!
    @IBOutlet weak var gameButton4: UIButton!
    @IBOutlet weak var alphabetGameButton: GameButton!
    @IBOutlet var gameButtonCollection: [GameButton]!
    @IBOutlet weak var soundButton: UIBarButtonItem!
    
    //MARK: - Properties
    var game = LanguageGame()
    var managedObjectContext: NSManagedObjectContext? = nil
    let userDefaults = NSUserDefaults.standardUserDefaults()

    let speakingSpeed: Float = NSUserDefaults.standardUserDefaults().floatForKey("speakingSpeed")
    var wordNumbers: [Int] = [0,0,0,0]
    var foreignWords: [Word] = []
    var alphabet: [Alphabet]? = nil
    
    //MARK: - Initialisers
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        game.saveLongestStreak()

        var error: NSErrorPointer = NSErrorPointer()
        if (managedObjectContext?.save(error) == nil) {
            println("Error: \(error.debugDescription)")
        } else {
            println("Managed Object Context save successful on GameViewController deinit")
        }
    }
    
    //MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        var error = NSErrorPointer()
        setStreakText()
        setButtonCollectionStyle()
        setSoundButton()
        fetchData(error)
        //set label to language's hi
        let hiFetchRequest = NSFetchRequest(entityName: "Word")
        hiFetchRequest.predicate = NSPredicate(format: "language.name = %@ AND englishWord.word = %@", userDefaults.stringForKey("language")!, "Hi")
        let temp = managedObjectContext?.executeFetchRequest(hiFetchRequest, error: error) as [Word]
        wordLabel.text = temp[0].word
//        var adView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
//        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait
//        self.view.addSubview(adView)
        //let layoutConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[button]-30-[button2]", options: NSLayoutFormatOptions, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //button.addConstraint(<#constraint: NSLayoutConstraint#>)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Game methods
    internal func setButtonCollectionStyle () {
        for gameButton in gameButtonCollection {
            gameButton.layer.cornerRadius = CGFloat(2)
            gameButton.titleLabel?.textAlignment = NSTextAlignment.Center
        }
    }
    
    internal func fetchData(error: NSErrorPointer) {
        var difficultyPredicateString: String = ""
        switch (userDefaults.stringForKey("difficulty")!) {
            case "Easy":
                difficultyPredicateString = "englishWord.difficulty = 'Easy'"
            case "Medium":
                difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium'}"
            case "Hard":
                difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium', 'Hard'}"
            default: abort()
        }
        switch (userDefaults.stringForKey("gameMode")!) {
        case "Intro Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = false", game.language)
            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Phrase Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", game.language)
            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Grammar Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", game.language)
            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Verb Mode":
            let fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", game.language)
            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        case "Alphabet Mode":
            let fetchRequest = NSFetchRequest(entityName: "Alphabet")
            fetchRequest.predicate = NSPredicate(format: "language = %@", game.language)
            self.alphabet = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as? [Alphabet]
            self.alphabet?.sort({Int($0.index) < Int($1.index)})
            wordLabel.text = self.alphabet?[0].uppercase
            alphabetGameButton.setTitle(self.alphabet?[0].lowercase, forState: .Normal)
        case "Dictation Mode":
            var fetchRequest = NSFetchRequest(entityName: "Word")
            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", game.language)
            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        default:
            break
        }
    }
    
    internal func setSoundButton () {
        if (self.userDefaults.boolForKey("hasSound") == true) {
            soundButton.title = "Sound On"
        } else {
            soundButton.title = "Sound Off"
        }
    }

    internal func refreshGame () {
        var index = 0
        do {
            wordNumbers[index] = Int(arc4random_uniform(UInt32(self.foreignWords.count)))
            if (index == 0) {
                index += 1
            } else if (!contains(wordNumbers[0...(index-1)], wordNumbers[index])) {
                index += 1
            }
        } while (index < 4)
        let correctButtonIndex = Int(arc4random_uniform(4))
        for gameButton in gameButtonCollection {
            if gameButton.gameButtonIndex == correctButtonIndex {
                gameButton.correct = true
                gameButton.setTitle(foreignWords[wordNumbers[gameButton.gameButtonIndex]].englishWord.word, forState: UIControlState.Normal)
                wordLabel.text = foreignWords[wordNumbers[gameButton.gameButtonIndex]].word
            } else {
                gameButton.correct = false
                gameButton.setTitle(foreignWords[wordNumbers[gameButton.gameButtonIndex]].englishWord.word, forState: UIControlState.Normal)
            }
            UIView.animateWithDuration(0.25, animations: {gameButton.alpha = 1})
        }
        setStreakText()
    }
    

    
    internal func endStreak () {
        game.saveLongestStreak()
        game.streak = 0
        setStreakText()
    }
    
    func setStreakText () {
        self.navigationItem.title = game.streakText
    }
    
    //MARK: Target action methods
    @IBAction func clickSoundButton(sender: UIBarButtonItem) {
        self.userDefaults.setBool(!userDefaults.boolForKey("hasSound"), forKey: "hasSound")
        setSoundButton()
    }

    @IBAction func clickGameButton(sender: GameButton) {
        game.attempts += 1
        //create a new NSNumber to increment managed objects
        var convertingNumber: NSNumber
        convertingNumber = NSNumber(int: game.language.attempts.intValue + 1)
        game.language.attempts = convertingNumber
        if wordNumbers != [0,0,0,0] {
            convertingNumber = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].attempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].attempts = convertingNumber
        }
        if (sender.correct) {
            if sender.currentTitle == nil {
                sayWord(wordLabel.text!, localWord: sender.currentAttributedTitle?.string)
            } else {
            sayWord(wordLabel.text!, localWord: sender.currentTitle!)
            }
            if wordNumbers != [0,0,0,0] {
                convertingNumber = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts.intValue + 1)
                foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts = convertingNumber
            }
            game.streak += 1
            game.correctAttempts += 1
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            convertingNumber = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts = convertingNumber
            endStreak()
        }
    }

    @IBAction func tapAlphabetButton(sender: GameButton) {
        sender.gameButtonIndex += 1
        if sender.gameButtonIndex >= self.alphabet?.count {
            sender.gameButtonIndex = 0
        }
        let word = alphabet?[sender.gameButtonIndex].uppercase
        let lower = alphabet?[sender.gameButtonIndex].lowercase
        sayWord(sender.currentTitle!, localWord: nil)//(word!, localWord: self.alphabet?[sender.gameButtonIndex].lowercase)
        sender.setTitle(self.alphabet?[sender.gameButtonIndex].lowercase, forState: UIControlState.Normal)
        wordLabel.text = self.alphabet?[sender.gameButtonIndex].lowercase
    }
    
    @IBAction func tapWordLabel(sender: UITapGestureRecognizer) {
        let label = sender.view as UILabel
        sayWord(label.text!, localWord: nil)
    }
    
    //MARK: Text to speech
    internal func sayWord (foreignWord: String, localWord: String?) {
        if self.userDefaults.boolForKey("hasSound") {
            let dataPlistPath: String = NSBundle.mainBundle().pathForResource("IETFLanguageCode", ofType:"strings")!
            let IETFCodeDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
            let synthesizer = AVSpeechSynthesizer()
            if ((localWord) != nil) {
                var utteranceAnswer = AVSpeechUtterance(string: localWord!)
//                var utteranceAnswer = AVSpeechUtterance(string: foreignWord)
                utteranceAnswer.rate = self.speakingSpeed
                println("Speaking local \(localWord!)")
                synthesizer.speakUtterance(utteranceAnswer)
            }
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            var utteranceWord = AVSpeechUtterance(string: foreignWord)
            if let languageCode = IETFCodeDictionary.valueForKey(userDefaults.stringForKey("language")!) as? String {
                utteranceWord.voice = AVSpeechSynthesisVoice(language: languageCode)
            }
            utteranceWord.rate = self.speakingSpeed
            println("Speaking foreign \(foreignWord)")
            synthesizer.speakUtterance(utteranceWord)
        }
    }
}

