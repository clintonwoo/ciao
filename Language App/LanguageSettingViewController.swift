//
//  LanguageSettingViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 14/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class LanguageSettingViewController: UITableViewController, UITableViewDelegate {
    
    //MARK: - Properties
    var game: LanguageGame!
    var delegate: SettingsDelegate!
    var languages = NSUserDefaults.standardUserDefaults().stringArrayForKey(Defaults.Languages) as! [String]
    
    //MARK: - Initialisers
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if ((delegate) != nil){
            delegate?.returnToSource(self, language: game.language)
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let label = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(150) as! UILabel
        game.language = label.text!
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return languages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as! UITableViewCell
        //set the current language with a tick accessory
        if (languages[indexPath.row] == game.language) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        var detailLabel = cell.viewWithTag(150) as! UILabel
        detailLabel.text = languages[indexPath.row] as String
        return cell
    }
    
    //MARK: - Segue
}