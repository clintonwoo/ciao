//
//  StatisticsViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 20/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var favouriteLanguage: UILabel!
    
    override init() {
        super.init()
    }
    
    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.favouriteLanguage.text = NSLocalizedString("gxu-b4-iuf.text", comment: "User's favourite language")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}