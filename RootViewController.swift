//
//  RootViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSettings(sender: UIButton) {
        self.presentViewController(<#viewControllerToPresent: UIViewController#>, animated: <#Bool#>, completion: <#(() -> Void)?##() -> Void#>)
    }
    
    //func pushViewController(viewController: UIViewController, animated: Bool) {
        
    //}
    
}
