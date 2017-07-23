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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class AlphabetGameViewController: GameMasterViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var alphabetGameButton: GameButton!
    
    //MARK: - Properties
    var alphabet: [Alphabet]!
    
    //MARK: - Initialisers    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let error: NSErrorPointer = nil
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
    func fetchData(_ error: NSErrorPointer) {
        var difficultyPredicateString: String = ""
        switch (game.difficulty) {
            case .easy:
                difficultyPredicateString = "englishWord.difficulty = 'Easy'"
            case .medium:
                difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium'}"
            case .hard:
                difficultyPredicateString = "englishWord.difficulty in {'Easy', 'Medium', 'Hard'}"
            default: abort()
        }
        switch (game.gameMode) {
        case .alphabetMode:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Alphabet)
            fetchRequest.predicate = NSPredicate(format: "language = %@", game.currentLanguageRecord!)
            do {
                try self.alphabet = coreDataDelegate.managedObjectContext?.fetch(fetchRequest) as? [Alphabet]
            } catch {
                print(error)
            }
            self.alphabet?.sorted(by: {Int($0.index) < Int($1.index)})
            wordLabel.text = self.alphabet?[0].uppercase
            alphabetGameButton.setTitle(self.alphabet?[0].lowercase, for: UIControlState())
//        case "Dictation Mode":
//            var fetchRequest = NSFetchRequest(entityName: "Word")
//            fetchRequest.predicate = NSPredicate(format: "\(difficultyPredicateString) AND language = %@ AND englishWord.inPhraseMode = true", game.language)
//            self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
        default:
            break
        }
    }

    //MARK: Target action methods
    @IBAction func tapAlphabetButton(_ sender: GameButton) {
        sender.gameButtonIndex += 1
        if sender.gameButtonIndex >= self.alphabet?.count {
            sender.gameButtonIndex = 0
        }
        let word = alphabet?[sender.gameButtonIndex].uppercase
        let lower = alphabet?[sender.gameButtonIndex].lowercase
        sayWord(sender.currentTitle!, localWord: nil)//(word!, localWord: self.alphabet?[sender.gameButtonIndex].lowercase)
        sender.setTitle(self.alphabet?[sender.gameButtonIndex].lowercase, for: UIControlState())
        wordLabel.text = self.alphabet?[sender.gameButtonIndex].lowercase
    }
}

