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

class MenuViewController: UIViewController {
    
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext? = nil
    
    //MARK: Outlets
    @IBOutlet var menuButtonCollection: [UIButton]!
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var gameModeButton: UIButton!
    @IBOutlet weak var grammarButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!

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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Segue
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case "Show Grammar":
                let destinationViewController = segue.destinationViewController as GrammarViewController
                let url = NSURL(string: "http://en.wikipedia.org/wiki/Italian_grammar")
                let urlRequest = NSURLRequest(URL: url!)
                destinationViewController.urlRequest = urlRequest
                //destinationViewController.webView?.loadRequest(urlRequest)
//                case "Show Game":
//                    let destinationViewController = segue.destinationViewController as GameViewController
//                    destinationViewController.managedObjectContext = self.managedObjectContext
//                    println(destinationViewController.description)
//                case "Show Settings":
//                    let navController = segue.destinationViewController as UINavigationController
//                    let destinationViewController = navController.topViewController as SettingsViewController
//                    destinationViewController.managedObjectContext = self.managedObjectContext
//                    println(destinationViewController.description)
            default:
                println("prepareForSegue: no segue logic on \(segue.identifier)")
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