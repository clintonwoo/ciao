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
    
    fileprivate enum SegueID: String {
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
        playGameButton.setTitle(Localization.Menu.PlayGame, for: UIControlState())
        gameModeButton.setTitle(Localization.Menu.ChooseMode, for: UIControlState())
        setGrammarButtonTitle(Foundation.UserDefaults.standard.string(forKey: UserDefaults.Language)!)
        statisticsButton.setTitle(Localization.Menu.Statistics, for: UIControlState())
        settingsButton.setTitle(Localization.Menu.Settings, for: UIControlState())
        
        // Create LanguageGame model
        game = LanguageGame(delegate: coreDataDelegate)
        
        // Set button style
        setButtonCollectionStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // First Run
        if Foundation.UserDefaults.standard.bool(forKey: UserDefaults.FirstRun) {
            let vc = ViewLoaderHelper.loadViewController(
                fromStoryBoard: StoryboardName.FirstRun,
                withStoryboardId: StoryboardID.TutorialNavigationVC,
                inBundle: nil) as UIViewController
            modalPresentationStyle = UIModalPresentationStyle.formSheet
            present(vc, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initialisers
    
    // MARK: - Methods
    
    func setGrammarButtonTitle (_ language: String) {
        grammarButton.setTitle(language + " " + Localization.Menu.Grammar, for: UIControlState())
    }
    
    internal func setButtonCollectionStyle () {
        for button in menuButtonCollection {
            //CALayer class properties
            button.layer.cornerRadius = CGFloat(6)
            button.layer.borderWidth = CGFloat(1)
            button.layer.borderColor = button.tintColor?.cgColor
            //UIColor.blueColor().CGColor
        }
    }
    
    //MARK: - Target action
    @IBAction func tapPlayGame(_ sender: UIButton) {
        if game.gameMode == .alphabetMode {
            performSegue(withIdentifier: SegueID.ShowAlphabetGame.rawValue, sender: sender)
        } else {
            performSegue(withIdentifier: SegueID.ShowGame.rawValue, sender: sender)
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier!) {
            case SegueID.ShowGame.rawValue:
                let destinationViewController = segue.destination as! GameViewController
                destinationViewController.coreDataDelegate = coreDataDelegate
                destinationViewController.game = game
            case SegueID.ShowModes.rawValue:
                let destinationViewController = segue.destination as! ModesViewController
                destinationViewController.game = game
            case SegueID.ShowAlphabetGame.rawValue:
                let destinationViewController = segue.destination as! AlphabetGameViewController
                destinationViewController.game = game
                destinationViewController.coreDataDelegate = coreDataDelegate
            case SegueID.ShowGrammar.rawValue:
                let destinationViewController = segue.destination as! GrammarViewController
                let dataPlistPath: String = Bundle.main.path(forResource: ResourceName.WikipediaGrammarURL.rawValue, ofType:ResourceName.WikipediaGrammarURL.ResourceFileType)!
                let dataPlistDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
                if let url = URL(string: dataPlistDictionary.value(forKey: Foundation.UserDefaults.standard.string(forKey: UserDefaults.Language)!) as! String) {
                    let urlRequest = URLRequest(url: url)
                    destinationViewController.urlRequest = urlRequest
//                  destinationViewController.webView?.loadRequest(urlRequest)
            }
            case SegueID.ShowStatistics.rawValue:
                NSUbiquitousKeyValueStore.default().synchronize()
                let destinationViewController = segue.destination as! StatisticsViewController
                destinationViewController.coreDataDelegate = coreDataDelegate
//                destinationViewController.game = game
            case SegueID.ShowSettings.rawValue:
                let destinationViewController = segue.destination as! SettingsViewController
                destinationViewController.delegate = self
                destinationViewController.game = game
        default:
            print("prepareForSegue: \(segue.identifier!) not found.")
        }
    }

    //MARK: - Language Setting Delegate
    
    func returnToSource(_ vc: UIViewController, language: String) {
        setGrammarButtonTitle(language)
    }
}
