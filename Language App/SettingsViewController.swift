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
    var managedObjectContext: NSManagedObjectContext? = nil
    
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
    /*Functions only required for dynamically loaded tables
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tvcLanguage", forIndexPath: indexPath) as UITableViewCell
        //cell.viewWithTag(150)
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return 4
    }*/
    
    //MARK: Segue
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
            case "Show Game":
                let destinationViewController = segue.destinationViewController as GameViewController
                destinationViewController.managedObjectContext = self.managedObjectContext
                println(destinationViewController.description)
            default:
                println("prepareForSegue: Unidentified segue on \(segue.identifier)")
            }
        }
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier, sender: sender)
    }
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
