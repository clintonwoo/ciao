//
//  RootViewController.swift
//  ciao-game
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class MenuViewController: UIViewController, SettingsDelegate {
    
    //MARK: - Outlets
    @IBOutlet var menuButtonCollection: [UIButton]!
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var gameModeButton: UIButton!
    @IBOutlet weak var grammarButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    //MARK: - Properties
    var coreDataDelegate: CoreDataDelegate!
    var game: LanguageGame!
    
    private enum SegueID: String {
        case ShowGame = "Show Game"
        case ShowAlphabetGame = "Show Alphabet Game"
        case ShowModes = "Show Modes"
        case ShowGrammar = "Show Grammar"
        case ShowStatistics = "Show Statistics"
        case ShowSettings = "Show Settings"
    }

    //MARK: - View controller methods
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        // Initialise localized button text
        playGameButton.setTitle(Localization.Menu.PlayGame, forState: .Normal)
        gameModeButton.setTitle(Localization.Menu.ChooseMode, forState: .Normal)
        setGrammarButtonTitle(NSUserDefaults.standardUserDefaults().stringForKey(UserDefaults.Language)!)
        statisticsButton.setTitle(Localization.Menu.Statistics, forState: .Normal)
        settingsButton.setTitle(Localization.Menu.Settings, forState: .Normal)
        
        // Create LanguageGame model
        game = LanguageGame(delegate: coreDataDelegate)
        
        // Set button style
        setButtonCollectionStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        // First Run
        if NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.FirstRun) {
            let vc = ViewLoaderHelper.loadViewController(
                fromStoryBoard: StoryboardName.FirstRun,
                withStoryboardId: StoryboardID.TutorialNavigationVC,
                inBundle: nil) as UIViewController
            modalPresentationStyle = UIModalPresentationStyle.FormSheet
            presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initialisers
    
    // MARK: - Methods
    
    func setGrammarButtonTitle (language: String) {
        grammarButton.setTitle(language + " " + Localization.Menu.Grammar, forState: UIControlState.Normal)
    }
    
    internal func setButtonCollectionStyle () {
        for button in menuButtonCollection {
            //CALayer class properties
            button.layer.cornerRadius = CGFloat(6)
            button.layer.borderWidth = CGFloat(1)
            button.layer.borderColor = button.tintColor?.CGColor
            //UIColor.blueColor().CGColor
        }
    }
    
    //MARK: - Target action
    @IBAction func tapPlayGame(sender: UIButton) {
        if game.gameMode == .AlphabetMode {
            performSegueWithIdentifier(SegueID.ShowAlphabetGame.rawValue, sender: sender)
        } else {
            performSegueWithIdentifier(SegueID.ShowGame.rawValue, sender: sender)
        }
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
            case SegueID.ShowGame.rawValue:
                let destinationViewController = segue.destinationViewController as! GameViewController
                destinationViewController.coreDataDelegate = coreDataDelegate
                destinationViewController.game = game
            case SegueID.ShowModes.rawValue:
                let destinationViewController = segue.destinationViewController as! ModesViewController
                destinationViewController.game = game
            case SegueID.ShowAlphabetGame.rawValue:
                let destinationViewController = segue.destinationViewController as! AlphabetGameViewController
                destinationViewController.game = game
                destinationViewController.coreDataDelegate = coreDataDelegate
            case SegueID.ShowGrammar.rawValue:
                let destinationViewController = segue.destinationViewController as! GrammarViewController
                let dataPlistPath: String = NSBundle.mainBundle().pathForResource(ResourceName.WikipediaGrammarURL.rawValue, ofType:ResourceName.WikipediaGrammarURL.Type)!
                let dataPlistDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
                if let url = NSURL(string: dataPlistDictionary.valueForKey(NSUserDefaults.standardUserDefaults().stringForKey(UserDefaults.Language)!) as! String) {
                    let urlRequest = NSURLRequest(URL: url)
                    destinationViewController.urlRequest = urlRequest
//                  destinationViewController.webView?.loadRequest(urlRequest)
            }
            case SegueID.ShowStatistics.rawValue:
                NSUbiquitousKeyValueStore.defaultStore().synchronize()
                let destinationViewController = segue.destinationViewController as! StatisticsViewController
                destinationViewController.coreDataDelegate = coreDataDelegate
//                destinationViewController.game = game
            case SegueID.ShowSettings.rawValue:
                let destinationViewController = segue.destinationViewController as! SettingsViewController
                destinationViewController.delegate = self
                destinationViewController.game = game
        default:
            println("prepareForSegue: \(segue.identifier!) not found.")
        }
    }

    //MARK: - Language Setting Delegate
    
    func returnToSource(vc: UIViewController, language: String) {
        setGrammarButtonTitle(language)
    }
}