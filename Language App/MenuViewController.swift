//
//  RootViewController.swift
//  Language App
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
    var game: LanguageGame!
    var managedObjectContext: NSManagedObjectContext!
    var coreDataDelegate: CoreDataDelegate!

    //MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonCollectionStyle()
        setGrammarButtonTitle(NSUserDefaults.standardUserDefaults().stringForKey("language")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    func setGrammarButtonTitle (language: String) {
        grammarButton.setTitle(language + " " + NSLocalizedString("Grammar",comment: "Show wikipedia grammar page button on menu"), forState: UIControlState.Normal)
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
    
    //MARK: - Language Setting Delegate
    func returnToSource(vc: UIViewController, language: String) {
        setGrammarButtonTitle(language)
    }
    
    //MARK: - Target action
    @IBAction func tapPlayGame(sender: UIButton) {
        if game.gameMode == "Alphabet Mode" {
            performSegueWithIdentifier("Show Alphabet Game", sender: sender)
        } else {
            performSegueWithIdentifier("Show Game", sender: sender)
        }
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case "Show Game":
                    let destinationViewController = segue.destinationViewController as! GameViewController
                    destinationViewController.coreDataDelegate = coreDataDelegate
                    destinationViewController.game = self.game
//                    destinationViewController.game.managedObjectContext = self.managedObjectContext
                    println("prepareForSegue: \(destinationViewController.description)")
                case "Show Modes":
                    let destinationViewController = segue.destinationViewController as! ModesViewController
                    destinationViewController.game = self.game
                    println("prepareForSegue: \(destinationViewController.description)")
                case "Show Alphabet Game":
                    let destinationViewController = segue.destinationViewController as! AlphabetGameViewController
                    destinationViewController.coreDataDelegate = coreDataDelegate
                    destinationViewController.game = self.game
                    println("Segue to \(destinationViewController.description)")
                case "Show Grammar":
                    let destinationViewController = segue.destinationViewController as! GrammarViewController
                    let dataPlistPath: String = NSBundle.mainBundle().pathForResource("WikipediaGrammarURL", ofType:"strings")!
                    let dataPlistDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
                    if let url = NSURL(string: dataPlistDictionary.valueForKey(NSUserDefaults.standardUserDefaults().stringForKey("language")!) as! String) {
                        let urlRequest = NSURLRequest(URL: url)
                        destinationViewController.urlRequest = urlRequest
                    }
                    println("prepareForSegue: \(destinationViewController.description)")
                    //destinationViewController.webView?.loadRequest(urlRequest)
                case "Show Statistics":
                    let destinationViewController = segue.destinationViewController as! StatisticsViewController
                    destinationViewController.coreDataDelegate = coreDataDelegate
                    destinationViewController.game = self.game
                    println("prepareForSegue: \(destinationViewController.description)")
                case "Show Settings":
                    let navController = segue.destinationViewController as! UINavigationController
                    let destinationViewController = navController.topViewController as! SettingsViewController
                    destinationViewController.game = self.game
                    destinationViewController.delegate = self
                    println("prepareForSegue: \(destinationViewController.description)")
            default:
                println("prepareForSegue: \(segue.identifier!) not found.")
            }
//        }
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier, sender: sender)
    }

    /*@IBAction func clickSettings(sender: UIButton) {
        self.presentViewController(SettingsController(), animated: true, completion: nil)
    }*/
    
    //func pushViewController(viewController: UIViewController, animated: Bool) {
        
    //}
}