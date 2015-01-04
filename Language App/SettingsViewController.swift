//
//  SettingsViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var data: NSMutableArray
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: Initialisers
    override init () {
        self.data = ["Comets", "Asteroids", "Moons"]
        super.init()
    }
    
    required init (coder: NSCoder) {
        self.data = ["Comets", "Asteroids", "Moons"]
        super.init(coder: coder)
    }
    
    //MARK: Data Source Delegate
    //Functions only required for dynamically loaded tables
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        var cell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
                        //cell.viewWithTag(150)
                        return cell
                    case 1:
                        var cell = tableView.dequeueReusableCellWithIdentifier("tvcSegmented", forIndexPath: indexPath) as UITableViewCell
                        return cell
                    default:
                        var cell = tableView.dequeueReusableCellWithIdentifier("tvcSegmented", forIndexPath: indexPath) as UITableViewCell
                        println("tableView:cellForRowAtIndexPath: row switch case defaulted")
                    return cell
                }
            case 1:
                switch (indexPath.row) {
                    case 0:
                        var cell = tableView.dequeueReusableCellWithIdentifier("tvcSwitch", forIndexPath: indexPath) as UITableViewCell
                        return cell
                    case 1:
                        var cell = tableView.dequeueReusableCellWithIdentifier("tvcSlider", forIndexPath: indexPath) as UITableViewCell
                        return cell
                    default:
                        var cell = tableView.dequeueReusableCellWithIdentifier("tvcSwitch", forIndexPath: indexPath) as UITableViewCell
                        println("tableView:cellForRowAtIndexPath: row switch case defaulted")
                        return cell
                }
            default:
                var cell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
                println("tableView:cellForRowAtIndexPath: section switch case defaulted")
                return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = ["Game Settings","Sound","Three"]
        return headerTitles[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        switch (numberOfRowsInSection) {
            case 0: return 2
            case 1: return 2
            default: return 1
        }
    }
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //var languageLabel = self.view.viewWithTag(102) as UILabel
        //languageLabel.text = userDefaults.stringForKey("language")
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
                case "Show Language":
                    let destinationViewController = segue.destinationViewController as LanguageSettingViewController
                    println("Segue to \(destinationViewController.description)")
                default:
                    println("prepareForSegue: Unidentified segue on \(segue.identifier)")
            }
//        }
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier, sender: sender)
    }
}
