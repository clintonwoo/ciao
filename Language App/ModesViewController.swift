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
    //MARK: - Outlets
    @IBOutlet var modeTableViewCells: [ModeTableViewCell]!
    
    //MARK: - Properties
    var game: LanguageGame!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var coreDataDelegate: CoreDataDelegate!
    
    //MARK: - Initialisers
    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setCheckedCell()
        //tableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.Right)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegate
    //Dictation Mode: Learn to Speak and Pronounce
    //Verb Mode: Learn the most common verbs
    //Grammar Mode: Learn the intricacies of Grammar
    //Counting Mode: Learn to count
    //Ultimate Mode: All the words are in it
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        setGameMode(cell?.textLabel?.text as String!)
        setCheckedCell()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Mode methods
    func setGameMode(mode: String) {
        userDefaults.setValue(mode, forKey: Defaults.GameMode)
        println("Set game mode to \(mode)")
    }
    
    func setCheckedCell () {
        for cell in modeTableViewCells {
            if game.gameMode == cell.textLabel?.text {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
}