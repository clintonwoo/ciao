//
//  AboutViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 3/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    //MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - About methods
    //MARK: Target action
    
    @IBAction func followOnTwitter(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/ClintonDAnnolfo")!)
    }
    
    @IBAction func connectOnLinkedIn(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://au.linkedin.com/in/clintondannolfo")!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
