//
//  SettingsViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, SettingsDelegate {
    
    //MARK: - Properties
    var game: LanguageGame!
    var delegate: SettingsDelegate!

    private enum DifficultyIndex: Int {
        //maps the difficulty to the segment in the segmented control
            case Easy = 0
            case Medium = 1
            case Hard = 2
    }
    
    private enum Cell {
        static let tvcLanguage = "tvcLanguage"
        static let tvcSegmented = "tvcSegmented"
        static let tvcSwitch = "tvcSwitch"
        static let tvcSlider = "tvcSlider"
        static let tvcAbout = "tvcAbout"
    }
    
    private enum SegueID: String {
        case ShowLanguage = "Show Language"
    }

    //MARK: - Initialisers

    //MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setLanguageLabel(game.language)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        if ((delegate) != nil){
            self.delegate?.returnToSource(self, language: game.language)
        }
    }

    //MARK: - Data Source Delegate
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
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcLanguage, forIndexPath: indexPath) as! UITableViewCell
                        let label = cell.viewWithTag(102) as! UILabel
                        label.text = game.language
                        return cell
                    case 1:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcSegmented, forIndexPath: indexPath) as! UITableViewCell
                        let segmentedControl = cell.viewWithTag(103) as! UISegmentedControl
                        switch (game.difficulty) {
                            case .Easy:
                                segmentedControl.selectedSegmentIndex = DifficultyIndex.Easy.rawValue
                            case .Medium:
                                segmentedControl.selectedSegmentIndex = DifficultyIndex.Medium.rawValue
                            case .Hard:
                                segmentedControl.selectedSegmentIndex = DifficultyIndex.Hard.rawValue
                            default:
                                break
                        }
                        return cell
//                    case 2:
//                        let cell = tableView.dequeueReusableCellWithIdentifier("tvcSwitch", forIndexPath: indexPath) as UITableViewCell
//                        let switchControl = cell.viewWithTag(104) as UISwitch
//                        switchControl.on = userDefaults.boolForKey("useLatinCharacters")
//                        let label = cell.viewWithTag(202) as UILabel
//                        label.text = NSLocalizedString("Use Latin-Based Alphabet", comment: "The label for the setting to always use Latin characters instead of language native alphabet")
//                        return cell
                    default:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcSegmented, forIndexPath: indexPath) as! UITableViewCell
                        println("tableView:cellForRowAtIndexPath: row switch case defaulted")
                    return cell
                }
            case 1:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcSwitch, forIndexPath: indexPath) as! UITableViewCell
                        var switchControl = cell.viewWithTag(104) as! UISwitch
                        switchControl.on = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.HasSound)
                        return cell
                    case 1:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcSlider, forIndexPath: indexPath) as! UITableViewCell
                        var slider = cell.viewWithTag(105) as! UISlider
                        slider.value = game.speakingSpeed
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcSwitch, forIndexPath: indexPath) as! UITableViewCell
                        println("tableView:cellForRowAtIndexPath: row switch case defaulted")
                        return cell
                }
            case 2:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcAbout, forIndexPath: indexPath) as! UITableViewCell
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcSwitch, forIndexPath: indexPath) as! UITableViewCell
                        println("tableView:cellForRowAtIndexPath: section 3 row switch case defaulted")
                        return cell
                }
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(Cell.tvcLanguage, forIndexPath: indexPath) as! UITableViewCell
                println("tableView:cellForRowAtIndexPath: section switch case defaulted")
                return cell
        }
    }
    
    //MARK: - Settings methods
    private func setLanguageLabel (language: String) {
        let languageCellIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let languageCell = self.tableView.cellForRowAtIndexPath(languageCellIndexPath)! as UITableViewCell
        var languageLabel = languageCell.viewWithTag(102) as! UILabel
        languageLabel.text = language
    }
    
    //MARK: Target action methods
    @IBAction func switchClicked(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: UserDefaults.HasSound)
    }
    
    @IBAction func segmentedClicked(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case DifficultyIndex.Easy.rawValue:
            game.difficulty = .Easy
        case DifficultyIndex.Medium.rawValue:
            game.difficulty = .Medium
        case DifficultyIndex.Hard.rawValue:
            game.difficulty = .Hard
        default:
            println("Difficulty segmented control clicked but no action taken")
        }
    }
    
    @IBAction func sliderClicked(sender: UISlider) {
        game.speakingSpeed = sender.value
    }
    
    //MARK: Language Setting Delegate
    func returnToSource(vc: UIViewController, language: String) {
        game.language = language
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case SegueID.ShowLanguage.rawValue:
                    var destinationViewController = segue.destinationViewController as! LanguageSettingViewController
                    destinationViewController.delegate = self
                    destinationViewController.game = game
                    println("Segue to \(destinationViewController.description)")
                default:
                    println("prepareForSegue: Unidentified segue on \(segue.identifier)")
            }
//        }
    }
}