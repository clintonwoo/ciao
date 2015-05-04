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

class AlphabetGameViewController: GameMasterViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var alphabetGameButton: GameButton!
    
    //MARK: - Properties
    var alphabet: [Alphabet]!
    
    //MARK: - Initialisers    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        var error = NSErrorPointer()
        setButtonCollectionStyle()
        fetchData(error)
//        var adView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
//        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait
//        self.view.addSubview(adView)
        //let layoutConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[button]-30-[button2]", options: NSLayoutFormatOptions, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //button.addConstraint(<#constraint: NSLayoutConstraint#>)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Game methods
    func fetchData(error: NSErrorPointer) {
        var difficultyPredicateString: String = ""
        switch (game.difficulty) {
            case .Easy:
                difficultyPredicateString = "englishWord.difficulty = 'Easy'"
            case .Medium:
                difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium'}"
            case .Hard:
                difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium', 'Hard'}"
            default: abort()
        }
        switch (game.gameMode) {
        case .AlphabetMode:
            let fetchRequest = NSFetchRequest(entityName: Entity.Alphabet)
            fetchRequest.predicate = NSPredicate(format: "language = %@", game.currentLanguageRecord)
            self.alphabet = coreDataDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as? [Alphabet]
            self.alphabet?.sort({Int($0.index) < Int($1.index)})
            wordLabel.text = self.alphabet?[0].uppercase
            alphabetGameButton.setTitle(self.alphabet?[0].lowercase, forState: .Normal)
//        case "Dictation Mode":
//            var fetchRequest = NSFetchRequest(entityName: "Word")
//            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", game.language)
//            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        default:
            break
        }
    }

    //MARK: Target action methods
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
}

