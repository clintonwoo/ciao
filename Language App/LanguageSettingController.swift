//
//  LanguageSettingController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 14/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class LanguageSettingController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var languages: NSMutableArray = ["Italian", "German", "Spanish", "Japanese", "Russian", "Chinese"]
    
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Data Source Delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
        //set the current language with a tick accessory cell.accessoryType = UITableViewCellAccessoryCheckmark
        let detailTagID: Int = 150
        var label: UILabel = cell.viewWithTag(detailTagID) as UILabel
        label.text = languages[indexPath.row] as? String
        //
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return languages.count
    }
    
    // MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Set the game's language
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    // MARK: Event Model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
