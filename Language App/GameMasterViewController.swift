//
//  GameMasterViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 21/02/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class GameMasterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var wordLabel: UILabel! /*{
        didSet {
            wordLabel.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:"pan:"))
        }
    }*/
    @IBOutlet var gameButtonCollection: [GameButton]!
    @IBOutlet weak var soundButton: UIBarButtonItem!
    
    //MARK: - Properties
    var game: LanguageGame!
    var coreDataDelegate: CoreDataDelegate!
        
    //MARK: - Initialisers    
    deinit {
        if coreDataDelegate.saveContext() {
            println("Managed Object Context save successful on \(self) deinit")
        }
    }
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        game.currentStreak = 0
        game.fetchData()
        // Set sound button text
        if (NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.HasSound)) {
            soundButton.title = Localization.Game.SoundOn
        } else {
            soundButton.title = Localization.Game.SoundOff
        }
        setButtonCollectionStyle()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //
    }
    
    // MARK: - Methods
    
    internal func setButtonCollectionStyle () {
        for gameButton in gameButtonCollection {
            gameButton.layer.cornerRadius = CGFloat(2)
            gameButton.titleLabel?.textAlignment = NSTextAlignment.Center
        }
    }
    
    // MARK: - Target Action
    
    @IBAction func tapWordLabel(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        sayWord(label.text!, localWord: nil)
    }
    
    @IBAction func tapSoundButton(sender: UIBarButtonItem?) {
        if (NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.HasSound)) {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: UserDefaults.HasSound)
            soundButton.title = Localization.Game.SoundOff
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: UserDefaults.HasSound)
            soundButton.title = Localization.Game.SoundOn
        }
    }
    
    //MARK: - Text to speech
    internal func sayWord (foreignWord: String, localWord: String?) {
        if NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.HasSound) {
            let dataPlistPath: String = NSBundle.mainBundle().pathForResource(ResourceName.IETFLanguageCode.rawValue, ofType:ResourceName.IETFLanguageCode.Type)!
            let IETFCodeDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
            let synthesizer = AVSpeechSynthesizer()
            if ((localWord) != nil) {
                var utteranceAnswer = AVSpeechUtterance(string: localWord!)
                //                var utteranceAnswer = AVSpeechUtterance(string: foreignWord)
                utteranceAnswer.rate = self.game.speakingSpeed
                println("Speaking local \(localWord!)")
                synthesizer.speakUtterance(utteranceAnswer)
            }
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            var utteranceWord = AVSpeechUtterance(string: foreignWord)
            if let languageCode = IETFCodeDictionary.valueForKey(NSUserDefaults.standardUserDefaults().stringForKey(UserDefaults.Language)!) as? String {
                utteranceWord.voice = AVSpeechSynthesisVoice(language: languageCode)
            }
            utteranceWord.rate = self.game.speakingSpeed
            println("Speaking foreign \(foreignWord)")
            synthesizer.speakUtterance(utteranceWord)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
