//
//  SettingsController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var data: NSMutableArray
    
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
    }

    */
    
    //MARK: Event Model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
