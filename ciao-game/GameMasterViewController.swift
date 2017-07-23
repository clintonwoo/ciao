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
            print("Managed Object Context save successful on \(self) deinit")
        }
    }
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        game.currentStreak = 0
        game.fetchData()
        // Set sound button text
        if (Foundation.UserDefaults.standard.bool(forKey: UserDefaults.HasSound)) {
            soundButton.title = Localization.Game.SoundOn
        } else {
            soundButton.title = Localization.Game.SoundOff
        }
        setButtonCollectionStyle()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //
    }
    
    // MARK: - Methods
    
    internal func setButtonCollectionStyle () {
        for gameButton in gameButtonCollection {
            gameButton.layer.cornerRadius = CGFloat(2)
            gameButton.titleLabel?.textAlignment = NSTextAlignment.center
        }
    }
    
    // MARK: - Target Action
    
    @IBAction func tapWordLabel(_ sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        sayWord(label.text!, localWord: nil)
    }
    
    @IBAction func tapSoundButton(_ sender: UIBarButtonItem?) {
        if (Foundation.UserDefaults.standard.bool(forKey: UserDefaults.HasSound)) {
            Foundation.UserDefaults.standard.set(false, forKey: UserDefaults.HasSound)
            soundButton.title = Localization.Game.SoundOff
        } else {
            Foundation.UserDefaults.standard.set(true, forKey: UserDefaults.HasSound)
            soundButton.title = Localization.Game.SoundOn
        }
    }
    
    //MARK: - Text to speech
    internal func sayWord (_ foreignWord: String, localWord: String?) {
        if Foundation.UserDefaults.standard.bool(forKey: UserDefaults.HasSound) {
            let dataPlistPath: String = Bundle.main.path(forResource: ResourceName.IETFLanguageCode.rawValue, ofType:ResourceName.IETFLanguageCode.ResourceFileType)!
            let IETFCodeDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
            let synthesizer = AVSpeechSynthesizer()
            if ((localWord) != nil) {
                let utteranceAnswer = AVSpeechUtterance(string: localWord!)
                //                var utteranceAnswer = AVSpeechUtterance(string: foreignWord)
                utteranceAnswer.rate = self.game.speakingSpeed
                print("Speaking local \(localWord!)")
                synthesizer.speak(utteranceAnswer)
            }
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            let utteranceWord = AVSpeechUtterance(string: foreignWord)
            if let languageCode = IETFCodeDictionary.value(forKey: Foundation.UserDefaults.standard.string(forKey: UserDefaults.Language)!) as? String {
                utteranceWord.voice = AVSpeechSynthesisVoice(language: languageCode)
            }
            utteranceWord.rate = self.game.speakingSpeed
            print("Speaking foreign \(foreignWord)")
            synthesizer.speak(utteranceWord)
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
