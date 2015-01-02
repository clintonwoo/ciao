//
//  AchievementsNavigationController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 13/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class ModesNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.Right)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    required init(coder: NSCoder){
        super.init()
    }
    
    override init(nibName: String?, bundle: NSBundle?){
        //if nibName != nil && bundle != nil{
        
        //}
        super.init(nibName: nibName, bundle: bundle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}