//
//  SettingsViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, LanguageSettingDelegate {
    
    //MARK: Properties
    var data: NSMutableArray = ["Comets", "Asteroids", "Moons"]
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    lazy var language: String = {self.userDefaults.stringForKey("language")}()!
    lazy var difficulty: String = {self.userDefaults.stringForKey("difficulty")!}()
    lazy var hasSound: Bool = {self.userDefaults.boolForKey("hasSound")}()
    lazy var volume: Float = {self.userDefaults.floatForKey("volume")}()

    enum Difficulty: Int {
        //maps the difficulty to the segment in the segmented control
            case Easy = 0
            case Medium = 1
            case Hard = 2
    }
    
    //MARK: Initialisers
    override init () {
        super.init()
    }
    
    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        if (self.language != userDefaults.stringForKey("language")) {
            userDefaults.setValue(self.language, forKey: "language")
        }
        if (self.difficulty != userDefaults.stringForKey("difficulty")) {
            userDefaults.setValue(self.difficulty, forKey: "difficulty")
        }
        if (self.hasSound != userDefaults.boolForKey("hasSound")) {
            userDefaults.setBool(self.hasSound, forKey: "hasSound")
        }
        if (self.volume != userDefaults.floatForKey("volume")) {
            userDefaults.setFloat(self.volume, forKey: "volume")
        }
    }
    
    //MARK: Data Source Delegate
    //Functions only required for dynamically loaded tables
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = ["Game Settings","Sound","About"]
        return headerTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        switch (numberOfRowsInSection) {
            case 0: return 2
            case 1: return 2
            case 2: return 1
            default: return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
                        var label = cell.viewWithTag(102) as UILabel
                        label.text = self.language
                        return cell
                    case 1:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSegmented", forIndexPath: indexPath) as UITableViewCell
                        var segmentedControl = cell.viewWithTag(103) as UISegmentedControl
                        switch (self.difficulty) {
                            case "Easy":
                                segmentedControl.selectedSegmentIndex = Difficulty.Easy.rawValue
                            case "Medium":
                                segmentedControl.selectedSegmentIndex = Difficulty.Medium.rawValue
                            case "Hard":
                                segmentedControl.selectedSegmentIndex = Difficulty.Hard.rawValue
                        default:
                            break
                        }
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSegmented", forIndexPath: indexPath) as UITableViewCell
                        println("tableView:cellForRowAtIndexPath: row switch case defaulted")
                    return cell
                }
            case 1:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSwitch", forIndexPath: indexPath) as UITableViewCell
                        var switchControl = cell.viewWithTag(104) as UISwitch
                        switchControl.on = self.hasSound
                        return cell
                    case 1:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSlider", forIndexPath: indexPath) as UITableViewCell
                        var slider = cell.viewWithTag(105) as UISlider
                        slider.value = self.volume
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSwitch", forIndexPath: indexPath) as UITableViewCell
                        println("tableView:cellForRowAtIndexPath: row switch case defaulted")
                        return cell
                }
            case 2:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcAbout", forIndexPath: indexPath) as UITableViewCell
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSwitch", forIndexPath: indexPath) as UITableViewCell
                        println("tableView:cellForRowAtIndexPath: section 3 row switch case defaulted")
                        return cell
                }
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
                println("tableView:cellForRowAtIndexPath: section switch case defaulted")
                return cell
        }
    }
    
    //MARK: Action Handlers
    @IBAction func switchClicked(sender: UISwitch) {
        self.hasSound = sender.on
    }
    
    @IBAction func segmentedClicked(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
            case Difficulty.Easy.rawValue:
                self.difficulty = "Easy"
            case Difficulty.Medium.rawValue:
                self.difficulty = "Medium"
            case Difficulty.Hard.rawValue:
                self.difficulty = "Hard"
            default:
                println("'Difficulty' Segmented Control clicked but no action taken")
        }
    }
    
    @IBAction func sliderClicked(sender: UISlider) {
        self.volume = sender.value
    }
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let languageCellIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let languageCell = self.tableView.cellForRowAtIndexPath(languageCellIndexPath)! as UITableViewCell
        var languageLabel = languageCell.viewWithTag(102) as UILabel
        languageLabel.text = self.language //userDefaults.stringForKey("language")
        //var languageLabel = self.view.viewWithTag(102) as UILabel
        //languageLabel.text = userDefaults.stringForKey("language")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Segue
    //Language Setting Delegate
    func returnToSource(vc: UIViewController, language: String) {
        self.language = language
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case "Show Language":
                    var destinationViewController = segue.destinationViewController as LanguageSettingViewController
                    destinationViewController.delegate = self
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