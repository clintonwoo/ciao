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
    
    @IBAction func ResetStats(sender: UIButton) {
        var storyBoard: UIStoryboard = UIStoryboard(name: "SecretStoryboard", bundle: NSBundle(path: "/Users/clintondannolfo/Desktop/Language App/Language App/SecretStoryboard.storyboard"))
        var initialViewController: UIViewController = storyBoard.instantiateInitialViewController() as UIViewController
        self.presentViewController(initialViewController, animated: true, completion: nil)
    }
    
    override init() {
        super.init()
    }
    
    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.favouriteLanguage.text = NSLocalizedString("Favourite Language: Italian mate!", comment: "User's favourite language")
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