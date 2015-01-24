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
    
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext? = nil
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: Outlets
    @IBOutlet var menuButtonCollection: [UIButton]!
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var gameModeButton: UIButton!
    @IBOutlet weak var grammarButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    //MARK: Delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in menuButtonCollection {
            //CALayer class properties
            button.layer.cornerRadius = CGFloat(6)
            button.layer.borderWidth = CGFloat(1)
            button.layer.borderColor = button.tintColor?.CGColor
            //UIColor.blueColor().CGColor
        }
        grammarButton.setTitle(userDefaults.stringForKey("language")! + " " + NSLocalizedString("Grammar",comment: "Show wikipedia grammar page button on menu"), forState: UIControlState.Normal)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Segue
    //Language Setting Delegate
    func returnToSource(vc: UIViewController, language: String) {
        grammarButton.setTitle(language + " " + NSLocalizedString("Grammar",comment: "Show wikipedia grammar page button on menu"), forState: UIControlState.Normal)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case "Show Grammar":
                    let destinationViewController = segue.destinationViewController as GrammarViewController
                    let dataPlistPath: String = NSBundle.mainBundle().pathForResource("wikipediaGrammarURL", ofType:"strings")!
                    let dataPlistDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
                    if let url = NSURL(string: dataPlistDictionary.valueForKey(userDefaults.stringForKey("language")!) as String) {
                        let urlRequest = NSURLRequest(URL: url)
                        destinationViewController.urlRequest = urlRequest
                    }
                    //destinationViewController.webView?.loadRequest(urlRequest)
                case "Show Game":
                    let destinationViewController = segue.destinationViewController as GameViewController
                    destinationViewController.managedObjectContext = self.managedObjectContext
                    println(destinationViewController.description)
                case "Show Statistics":
                    let destinationViewController = segue.destinationViewController as StatisticsViewController
                    destinationViewController.managedObjectContext = self.managedObjectContext
                    println(destinationViewController.description)
                case "Show Settings":
                    let navController = segue.destinationViewController as UINavigationController
                    let destinationViewController = navController.topViewController as SettingsViewController
                    destinationViewController.delegate = self
//                    destinationViewController.managedObjectContext = self.managedObjectContext
                    println(destinationViewController.description)
                
            default:
                println("prepareForSegue: no segue logic on \(segue.identifier)")
            }
//        }
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier, sender: sender)
    }
    
    func getCurrentLanguageWikipediaGrammarURL () /* -> NSURL */ {
//        switch(userDefaults.stringForKey("language")!) {
//            case "Italian": url = NSURL(string: "http://en.wikipedia.org/wiki/Italian_grammar")!
//            case "Arabic": url = NSURL("")
//            case "Chinese": url = NSURL("")
//            case "Chinese (Hong Kong SAR China)": url = NSURL("")
//            case "Chinese (Taiwan)": url = NSURL("")
//            case "Czech": url = NSURL("")
//            case "Danish": url = NSURL("")
//            case "Dutch (Belgium)": url = NSURL("")
//            case "Dutch (Netherlands)": url = NSURL("")
//            case "English (Australia)": url = NSURL("")
//            case "English (Ireland)": url = NSURL("")
//            case "English (South Africa)": url = NSURL("")
//            case "English (United Kingdom)": url = NSURL("")
//            case "English (United States)": url = NSURL("")
//            case "Finnish": url = NSURL("")
//            case "French (Canada)": url = NSURL("")
//            case "French (France)": url = NSURL("")
//            case "German": url = NSURL("")
//            case "Greek": url = NSURL("")
//            case "Hebrew": url = NSURL("")
//            case "Hindi": url = NSURL("")
//            case "Hungarian": url = NSURL("")
//            case "Indonesian": url = NSURL("")
//            case "Italian": url = NSURL("")
//            case "Japanese": url = NSURL("")
//            case "Korean": url = NSURL("")
//            case "Norwegian": url = NSURL("")
//            case "Polish": url = NSURL("")
//            case "Portuguese (Brazil)": url = NSURL("")
//            case "Portuguese (Portugal)": url = NSURL("")
//            case "Romanian": url = NSURL("")
//            case "Russian": url = NSURL("")
//            case "Slovak": url = NSURL("")
//            case "Spanish (Mexico)": url = NSURL("")
//            case "Spanish (Spain)": url = NSURL("")
//            case "Swedish": url = NSURL("")
//            case "Thai": url = NSURL("")
//            case "Turkish": url = NSURL("")
//        default:
//            println("error, URL for wikipedia language grammar page not known")
//            url = NSURL()
//        }
//        return url
    }

    /*@IBAction func clickSettings(sender: UIButton) {
        self.presentViewController(SettingsController(), animated: true, completion: nil)
    }*/
    
    //func pushViewController(viewController: UIViewController, animated: Bool) {
        
    //}
}