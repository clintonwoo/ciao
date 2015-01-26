//
//  AchievementsViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 8/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class ModesViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Outlets
    @IBOutlet var modeTableViewCells: [ModeTableViewCell]!
    
    //MARK: Initialisers
    override init () {
        super.init()
    }

    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        NSUserDefaults.standardUserDefaults().setValue(cell?.textLabel?.text, forKey: "gameMode")
        setCheckmark()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setCheckmark()
        //tableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.Right)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCheckmark () {
        for cell in modeTableViewCells {
            if NSUserDefaults.standardUserDefaults().stringForKey("gameMode") == cell.textLabel?.text {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
}