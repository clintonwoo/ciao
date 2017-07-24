//
//  TutorialItemViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 12/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class TutorialItemViewController: UIViewController {
    
    // MARK: - Properties
    
    var index: Int!
    
    // MARK: - Outlets
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the page background to white
        self.view.backgroundColor = UIColor.white
    }
}
