//
//  LanguageSettingViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 14/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

protocol LanguageSettingDelegate {
    func returnToSource(vc: UIViewController, language: String )
}

class LanguageSettingViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var delegate: SettingsViewController? = nil
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var languages = NSUserDefaults.standardUserDefaults().stringArrayForKey("languages") as [String]
    var language = NSUserDefaults.standardUserDefaults().stringForKey("language")
    
    //MARK: Initialisers
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let label = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(150) as UILabel
        self.language = label.text!
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Table View Data Source Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return languages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
        //set the current language with a tick accessory cell.accessoryType = UITableViewCellAccessoryCheckmark
        var detailLabel = cell.viewWithTag(150) as UILabel
        detailLabel.text = languages[indexPath.row] as String
        return cell
    }
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if ((delegate) != nil){
            self.delegate?.returnToSource(self, language: self.language!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//            let destinationViewController = segue.destinationViewController as SettingsViewController
//            destinationViewController.language = self.language!
//            println("Segue to \(destinationViewController.description)")
    }
}