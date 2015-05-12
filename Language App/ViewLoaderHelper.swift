//
//  ViewLoaderHelper.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 12/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class ViewLoaderHelper {
    class func loadViewController(fromStoryBoard storyboard: String, withStoryboardId id: String, inBundle bundle: NSBundle?) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(id) as! UIViewController!
        return viewController
    }
}
