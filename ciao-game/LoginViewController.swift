//
//  LoginViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 12/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class LoginViewController: TutorialItemViewController {
    
    
    @IBAction func tapSkipLoginButton(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: UserDefaults.isUserLoggedIn)
        if let vc = parentViewController as? TutorialViewController {
            vc.setViewControllers(
                [vc.viewControllerForIndex(1)],
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: true,
                completion: nil)
            
        }
    }
}