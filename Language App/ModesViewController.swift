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
    
    var data: NSMutableArray
    
    override init () {
        self.data = ["Comets", "Asteroids", "Moons"]
        super.init()
    }
    
    required init (coder: NSCoder) {
        self.data = ["Comets", "Asteroids", "Moons"]
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.Right)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}