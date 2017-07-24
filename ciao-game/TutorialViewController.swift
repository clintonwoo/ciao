//
//  TutorialViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 12/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    
    var visualEffectView: UIVisualEffectView!
    
    // MARK: - View Controller Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Commenting the blur effect out for now as the background colours clash with page vc bg
        //        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)) as UIVisualEffectView
        //        visualEffectView.frame = self.view.bounds
        //        visualEffectView.backgroundColor = UIColor.clearColor()
        //        self.view.insertSubview(visualEffectView, atIndex: 0)
        
        // Initialise the first view controller
        setViewControllers([viewControllerForIndex(0)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        // Set an appearance for the page control at the bottom
        let pagecontrol = UIPageControl.appearance()
        pagecontrol.pageIndicatorTintColor = UIColor.gray //UIColor.appGrey1Color()
        pagecontrol.currentPageIndicatorTintColor = UIColor.blue //UIColor.appBlueColor()
        pagecontrol.backgroundColor = UIColor.white
        
        // Set the nav bar to transparent and page view controller background to white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    // MARK: - Page View Controller
    
    @objc(pageViewController:willTransitionToViewControllers:) func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [AnyObject]) {
        // If the user aborts the navigation gesture, the transition doesn’t complete and the view controllers stay the same.
    }
    
    // MARK: - Page View Controller Data Source
    
    @objc func pageViewController (_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? TutorialItemViewController {
            if vc.index > 0 {
                return viewControllerForIndex(vc.index - 1)
            }
        }
        return nil
    }
    
    func pageViewController (_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if Foundation.UserDefaults.standard.bool(forKey: UserDefaults.isUserLoggedIn) {
            if let vc = viewController as? LoginViewController {
                if vc.index + 1 < ImageName.TutorialImages.count {
                    return viewControllerForIndex(vc.index + 1)
                }
                return nil
            }
            if let vc = viewController as? TutorialItemViewController {
                // + 1 to make up for 0 index
                if vc.index + 1 < ImageName.TutorialImages.count {
                    return viewControllerForIndex(vc.index + 1)
                }
            }
        }
        return nil
    }
    
    func viewControllerForIndex (_ index: Int) -> TutorialItemViewController {
        switch index {
        case 0:
            let vc = ViewLoaderHelper.loadViewController(
                fromStoryBoard: StoryboardName.FirstRun,
                withStoryboardId: StoryboardID.Login,
                inBundle: nil) as! LoginViewController
            vc.index = index
            return vc
        default:
            let vc = ViewLoaderHelper.loadViewController(
                fromStoryBoard: StoryboardName.FirstRun,
                withStoryboardId: StoryboardID.TutorialPageVC,
                inBundle: nil) as! TutorialPageViewController
            vc.index = index
            return vc
        }
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return ImageName.TutorialImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // The presentation index for the page view controller. Called whenever setViewControllers is run on the page view controller.
        if pageViewController.viewControllers?.count != 0 {
            return (pageViewController.viewControllers![0] as! TutorialItemViewController).index
        }
        return 0
    }
    
    // MARK: - Target Action
    
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        Foundation.UserDefaults.standard.set(false, forKey: UserDefaults.FirstRun)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

