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
    var currentLanguageAttempts: Int
    var languageAttempts = NSMutableDictionary(dictionary: NSUserDefaults.standardUserDefaults().dictionaryForKey("languageAttempts")!)
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
        self.currentLanguageAttempts = self.languageAttempts.valueForKey(self.userDefaults.stringForKey("language")!) as Int
        super.init()
    }
    
    required init(coder: NSCoder) {
        self.currentLanguageAttempts = self.languageAttempts.valueForKey(self.userDefaults.stringForKey("language")!) as Int
        super.init(coder: coder)
    }
    
    deinit {
        saveUserDefaultLongestStreak()
        userDefaults.setInteger(self.attempts, forKey: "attempts")
        userDefaults.setInteger(self.correctAttempts, forKey: "correctAttempts")
        languageAttempts.setValue(self.currentLanguageAttempts, forKey: self.userDefaults.stringForKey("language")!)
        userDefaults.setObject(self.languageAttempts, forKey: "languageAttempts")
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
        var fetchRequest = NSFetchRequest()
        var entity: NSEntityDescription = NSEntityDescription.entityForName("Word", inManagedObjectContext: self.managedObjectContext!)!
        var predicate = NSPredicate(format: "language = %@", userDefaults.stringForKey("language")!)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        var error: NSErrorPointer = NSErrorPointer()
        self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
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
        self.currentLanguageAttempts += 1
        //create a new NSNumber to increment itself
        var number: NSNumber
        if wordNumbers != [0,0,0,0] {
            number = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].attempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].attempts = number
        }
        if (sender.correct) {
            sayWord(wordLabel.text!, answer: sender.currentTitle!)
            if wordNumbers != [0,0,0,0] {
                number = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts.intValue + 1)
                foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts = number
            }
            self.streak += 1
            self.correctAttempts += 1
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            number = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts = number
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
                //wordLabel.text = answers[wordNumbers[gameButton.gameButtonIndex]]
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
    
    func sayWord (word: String, answer: String) {
        if self.userDefaults.boolForKey("hasSound") {
            var languageCode: String
            switch (userDefaults.stringForKey("language")!) {
                case "Arabic": languageCode = "ar-SA"
                case "Chinese": languageCode = "zh-CN"
                case "Chinese (Hong Kong SAR China)": languageCode = "zh-HK"
                case "Chinese (Taiwan)": languageCode = "zh-TW"
                case "Czech": languageCode = "cs-CZ"
                case "Danish": languageCode = "da-DK"
                case "Dutch (Belgium)": languageCode = "nl-BE"
                case "Dutch (Netherlands)": languageCode = "nl-NL"
                case "English (Australia)": languageCode = "en-AU"
                case "English (Ireland)": languageCode = "en-IE"
                case "English (South Africa)": languageCode = "en-ZA"
                case "English (United Kingdom)": languageCode = "en-GB"
                case "English (United States)": languageCode = "en-US"
                case "Finnish": languageCode = "fi-FI"
                case "French (Canada)": languageCode = "fr-CA"
                case "French (France)": languageCode = "fr-FR"
                case "German": languageCode = "de-DE"
                case "Greek": languageCode = "el-GR"
                case "Hebrew": languageCode = "he-IL"
                case "Hindi": languageCode = "hi-IN"
                case "Hungarian": languageCode = "hu-HU"
                case "Indonesian": languageCode = "id-ID"
                case "Italian": languageCode = "it-IT"
                case "Japanese": languageCode = "ja-JP"
                case "Korean": languageCode = "ko-KR"
                case "Norwegian": languageCode = "no-NO"
                case "Polish": languageCode = "pl-PL"
                case "Portuguese (Brazil)": languageCode = "pt-BR"
                case "Portuguese (Portugal)": languageCode = "pt-PT"
                case "Romanian": languageCode = "ro-RO"
                case "Russian": languageCode = "ru-RU"
                case "Slovak": languageCode = "sk-SK"
                case "Spanish (Mexico)": languageCode = "es-MX"
                case "Spanish (Spain)": languageCode = "es-ES"
                case "Swedish": languageCode = "sv-SE"
                case "Thai": languageCode = "th-TH"
                case "Turkish": languageCode = "tr-TR"
                default: languageCode = "en-US"
            }
            var utteranceAnswer: AVSpeechUtterance = AVSpeechUtterance(string: answer)
            var utteranceWord: AVSpeechUtterance = AVSpeechUtterance(string: word)
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            utteranceAnswer.rate = self.speakingSpeed
            utteranceWord.voice = AVSpeechSynthesisVoice(language: languageCode)
            utteranceWord.rate = self.speakingSpeed
            var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utteranceAnswer)
            synthesizer.speakUtterance(utteranceWord)
        }
    }
}

