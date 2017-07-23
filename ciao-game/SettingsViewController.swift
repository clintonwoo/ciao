//
//  SettingsViewController.swift
//  ciao-game
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController , SettingsDelegate {
    
    //MARK: - Properties
    var game: LanguageGame!
    var delegate: SettingsDelegate!

    fileprivate enum DifficultyIndex: Int {
        //maps the difficulty to the segment in the segmented control
            case easy = 0
            case medium = 1
            case hard = 2
    }
    
    fileprivate enum Cell {
        static let tvcLanguage = "tvcLanguage"
        static let tvcSegmented = "tvcSegmented"
        static let tvcSwitch = "tvcSwitch"
        static let tvcSlider = "tvcSlider"
        static let tvcAbout = "tvcAbout"
    }
    
    fileprivate enum SegueID: String {
        case ShowLanguage = "Show Language"
    }

    //MARK: - Initialisers

    //MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localization.Title.Settings
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLanguageLabel(game.language)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        if ((delegate) != nil){
            self.delegate?.returnToSource(self, language: game.language)
        }
    }

    //MARK: - Data Source Delegate
    //Functions only required for dynamically loaded tables
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = [Localization.Settings.Headers.GameSettings,
            Localization.Settings.Headers.Sound,
            Localization.Settings.Headers.About]
        return headerTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        switch (numberOfRowsInSection) {
            case 0: return 2
            case 1: return 2
            case 2: return 1
            default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcLanguage, for: indexPath) 
                        (cell.viewWithTag(100) as! UILabel).text = Localization.Settings.Language
                        (cell.viewWithTag(200) as! UILabel).text = game.language
                        return cell
                    case 1:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcSegmented, for: indexPath) 
                        (cell.viewWithTag(101) as! UILabel).text = Localization.Settings.Difficulty
                        let segmentedControl = cell.viewWithTag(201) as! UISegmentedControl
                        switch (game.difficulty) {
                            case .easy:
                                segmentedControl.selectedSegmentIndex = DifficultyIndex.easy.rawValue
                            case .medium:
                                segmentedControl.selectedSegmentIndex = DifficultyIndex.medium.rawValue
                            case .hard:
                                segmentedControl.selectedSegmentIndex = DifficultyIndex.hard.rawValue
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
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcSegmented, for: indexPath) 
                        print("tableView:cellForRowAtIndexPath: row switch case defaulted")
                    return cell
                }
            case 1:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcSwitch, for: indexPath) 
                        (cell.viewWithTag(102) as! UILabel).text = Localization.Settings.SoundEnabled
                        (cell.viewWithTag(202) as! UISwitch).isOn = Foundation.UserDefaults.standard.bool(forKey: UserDefaults.HasSound)
                        return cell
                    case 1:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcSlider, for: indexPath) 
                        (cell.viewWithTag(103) as! UILabel).text = Localization.Settings.SpeakingSpeed
                        (cell.viewWithTag(203) as! UISlider).value = game.speakingSpeed
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcSwitch, for: indexPath) 
                        print("tableView:cellForRowAtIndexPath: row switch case defaulted")
                        return cell
                }
            case 2:
                switch (indexPath.row) {
                    case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcAbout, for: indexPath) 
//                        cell.detailTextLabel?.text = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
                        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
                        cell.textLabel?.text = Localization.Settings.About
                        cell.detailTextLabel?.text = "v\(version)" //(\(build)) "
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcSwitch, for: indexPath) 
                        print("tableView:cellForRowAtIndexPath: section 3 row switch case defaulted")
                        return cell
                }
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tvcLanguage, for: indexPath) 
                print("tableView:cellForRowAtIndexPath: section switch case defaulted")
                return cell
        }
    }
    
    //MARK: - Settings methods
    fileprivate func setLanguageLabel (_ language: String) {
        let languageCellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
        let languageCell = self.tableView.cellForRow(at: languageCellIndexPath)! as UITableViewCell
        let languageLabel = languageCell.viewWithTag(200) as! UILabel
        languageLabel.text = language
    }
    
    //MARK: Target action methods
    @IBAction func switchClicked(_ sender: UISwitch) {
        Foundation.UserDefaults.standard.set(sender.isOn, forKey: UserDefaults.HasSound)
    }
    
    @IBAction func segmentedClicked(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case DifficultyIndex.easy.rawValue:
            game.difficulty = .easy
        case DifficultyIndex.medium.rawValue:
            game.difficulty = .medium
        case DifficultyIndex.hard.rawValue:
            game.difficulty = .hard
        default:
            print("Difficulty segmented control clicked but no action taken")
        }
    }
    
    @IBAction func sliderClicked(_ sender: UISlider) {
        game.speakingSpeed = sender.value
    }
    
    //MARK: Language Setting Delegate
    func returnToSource(_ vc: UIViewController, language: String) {
        game.language = language
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case SegueID.ShowLanguage.rawValue:
                    var destinationViewController = segue.destination as! LanguageSettingViewController
                    destinationViewController.delegate = self
                    destinationViewController.game = game
                    print("Segue to \(destinationViewController.description)")
                default:
                    print("prepareForSegue: Unidentified segue on \(segue.identifier)")
            }
//        }
    }
}
