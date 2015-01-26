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
    
    //MARK: Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var gameButton1: UIButton!
    @IBOutlet weak var gameButton2: UIButton!
    @IBOutlet weak var gameButton3: UIButton!
    @IBOutlet weak var gameButton4: UIButton!
    @IBOutlet var gameButtonCollection: [GameButton]!
    @IBOutlet weak var soundButton: UIBarButtonItem!
    
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext? = nil
    var userDefaults = NSUserDefaults.standardUserDefaults()
    lazy var language: Language = {
        var languageFetchRequest = NSFetchRequest()
        let languageEntity: NSEntityDescription = NSEntityDescription.entityForName("Language", inManagedObjectContext: self.managedObjectContext!)!
        let languagePredicate = NSPredicate(format: "name = %@", self.userDefaults.stringForKey("language")!)
        languageFetchRequest.entity = languageEntity
        languageFetchRequest.predicate = languagePredicate
        var error = NSErrorPointer()
        let languageRecords = self.managedObjectContext?.executeFetchRequest(languageFetchRequest, error: error) as [Language]
        return languageRecords[0]
    }()
    var attempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("attempts")
    var correctAttempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("correctAttempts")
    var streak: Int = 0
    var streakText: String {
        return NSLocalizedString("Streak: \(self.streak)", comment: "Navigation bar title showing the user's streak.")
    }
    var speakingSpeed: Float = NSUserDefaults.standardUserDefaults().floatForKey("speakingSpeed")
    var wordNumbers: [Int] = [0,0,0,0]
    var foreignWords: [Word] = []
    
    //MARK: Initialisers
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        saveUserDefaultLongestStreak()
        userDefaults.setInteger(self.attempts, forKey: "attempts")
        userDefaults.setInteger(self.correctAttempts, forKey: "correctAttempts")
        var error: NSErrorPointer = NSErrorPointer()
        if (managedObjectContext?.save(error) == nil) {
            println("Error: \(error.debugDescription)")
        } else {
            println("Managed Object Context save successful on GameViewController deinit")
        }
    }
    
    //MARK: View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for gameButton in gameButtonCollection {
            gameButton.layer.cornerRadius = CGFloat(2)
        }
        if (self.userDefaults.boolForKey("hasSound") == true) {
            soundButton.title = "Sound On"
        } else {
            soundButton.title = "Sound Off"
        }
        var error = NSErrorPointer()
        switch (userDefaults.stringForKey("gameMode")!) {
            case "Intro Mode":
                var fetchRequest = NSFetchRequest(entityName: "Word")
                fetchRequest.predicate = NSPredicate(format: "language = %@ AND englishWord.inPhraseMode = false", self.language)
                self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
            case "Phrase Mode":
                var fetchRequest = NSFetchRequest(entityName: "Word")
                fetchRequest.predicate = NSPredicate(format: "language = %@ AND englishWord.inPhraseMode = true", self.language)
                self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        default:
            break
        }
        //set label to language's hi
        var hiFetchRequest = NSFetchRequest(entityName: "Word")
        hiFetchRequest.predicate = NSPredicate(format: "language.name = %@ AND englishWord.word = %@", userDefaults.stringForKey("language")!, "Hi")
        let temp = managedObjectContext?.executeFetchRequest(hiFetchRequest, error: error) as [Word]
        wordLabel.text = temp[0].word
//        var adView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
//        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait
//        self.view.addSubview(adView)
        //adView

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
    
    //MARK: Game methods
    @IBAction func clickSoundButton(sender: UIBarButtonItem) {
        if (self.userDefaults.boolForKey("hasSound") == true) {
            self.userDefaults.setBool(false, forKey: "hasSound")
            sender.title = "Sound Off"
        } else {
            self.userDefaults.setBool(true, forKey: "hasSound")
            sender.title = "Sound On"
        }
    }
    
    @IBAction func clickGameButton(sender: GameButton) {
        self.attempts += 1
        //create a new NSNumber to increment managed objects
        var convertingNumber: NSNumber
        convertingNumber = NSNumber(int: language.attempts.intValue + 1)
        language.attempts = convertingNumber
        if wordNumbers != [0,0,0,0] {
            convertingNumber = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].attempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].attempts = convertingNumber
        }
        if (sender.correct) {
            sayWord(wordLabel.text!, answer: sender.currentTitle!)
            if wordNumbers != [0,0,0,0] {
                convertingNumber = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts.intValue + 1)
                foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts = convertingNumber
            }
            self.streak += 1
            self.correctAttempts += 1
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            convertingNumber = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts = convertingNumber
            endStreak()
        }
    }

    func refreshGame () {
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
        self.navigationItem.title = streakText
    }
    
    private func saveUserDefaultLongestStreak () {
        if userDefaults.integerForKey("longestStreak") < streak {
            userDefaults.setInteger(streak, forKey: "longestStreak")
        }
    }
    
    internal func endStreak () {
        saveUserDefaultLongestStreak()
        self.streak = 0
        self.navigationItem.title = streakText
    }
    
    //MARK: Text to speech
    @IBAction func tapWordLabel(sender: UITapGestureRecognizer) {
        let label = sender.view as UILabel
        sayWord(label.text!, answer: nil)
    }
    
    func sayWord (word: String, answer: String?) {
        if self.userDefaults.boolForKey("hasSound") {
            let dataPlistPath: String = NSBundle.mainBundle().pathForResource("IETFLanguageCode", ofType:"strings")!
            let IETFCodeDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
            var synthesizer = AVSpeechSynthesizer()
            if ((answer) != nil) {
                var utteranceAnswer = AVSpeechUtterance(string: answer)
                utteranceAnswer.rate = self.speakingSpeed
                synthesizer.speakUtterance(utteranceAnswer)
            }
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            var utteranceWord = AVSpeechUtterance(string: word)
            if let languageCode = IETFCodeDictionary.valueForKey(userDefaults.stringForKey("language")!) as? String {
                utteranceWord.voice = AVSpeechSynthesisVoice(language: languageCode)
            }
            utteranceWord.rate = self.speakingSpeed
            synthesizer.speakUtterance(utteranceWord)
        }
    }
}

