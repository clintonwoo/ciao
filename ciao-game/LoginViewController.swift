//
//  LoginViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 12/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: TutorialItemViewController {
    
    
    @IBAction func tapSkipLoginButton(_ sender: UIButton) {
        Foundation.UserDefaults.standard.set(true, forKey: UserDefaults.isUserLoggedIn)
        if let vc = self.parent as? TutorialViewController {
            vc.setViewControllers(
                [vc.viewControllerForIndex(1)],
                direction: UIPageViewControllerNavigationDirection.forward,
                animated: true,
                completion: nil)
            
        }
    }
}
