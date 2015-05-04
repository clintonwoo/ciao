//
//  GrammarViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 11/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import UIKit

class GrammarViewController: UIViewController, UIWebViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    let userDefaults = NSUserDefaults.standardUserDefaults()
    lazy var willCacheGrammarPages: Bool = {self.userDefaults.boolForKey("willCacheGrammarPages")}()
    var urlRequest: NSURLRequest? = nil
    var backButton: UIBarButtonItem? = nil
    var forwardButton: UIBarButtonItem? = nil
    
    //MARK: - Initialisers
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: - View Controller
    //MARK: Protocol
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
//        webView.st
        self.backButton = UIBarButtonItem(title:"Back", style: UIBarButtonItemStyle.Plain, target: self.webView, action: "goBack")
        self.forwardButton = UIBarButtonItem(title:"Forward", style: UIBarButtonItemStyle.Plain, target: self.webView, action: "goForward")
        setForwardBackwardButton(false, canGoBack: false)
//        addContainerViewController(webCacheViewController)
        //        var toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 90, 50))
        //        var v1: UISwitch = UISwitch()
        //        var v2: UILabel = UILabel()
        //        var vArray: NSMutableArray = NSMutableArray(capacity: 2)
        //        vArray.addObject(v1)
        //        vArray.addObject(v2)
        
        //        toolbar.setItems(vArray, animated: false)
        
        //        var placeholderView: UIView = UIView(frame: CGRectMake(0, 0, 100, 40))
        //        placeholderView.backgroundColor = UIColor.whiteColor()
        //        var switchView = UISwitch()
        //        switchView.on = true
        //        var label = UILabel()
        //        label.frame = CGRectMake(0, 0, 50, 50)
        //        label.text = "Cache"
        //        label.textColor = UIColor.blackColor()
        //        placeholderView.addSubview(switchView)
        //        placeholderView.addSubview(label)
        //        self.navigationItem.titleView = placeholderView
        
        //        self.navigationItem.titleView = titleView
        //self.navigationItem.titleView?.frameForAlignmentRect(CGRectA)
        
        //self.switchWithTitle?.switchView.on = self.willCacheGrammarPages
        //self.navigationItem.titleView = self.switchWithTitle
        //        self.navigationItem.titleView = toolbar
        self.navigationItem.rightBarButtonItems = [self.forwardButton!, self.backButton!]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if ((urlRequest) != nil){
            self.webView.loadRequest(urlRequest!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Container
    func addContainerViewController (viewController: UIViewController) {
//        self.addChildViewController(viewController)
        println("Running method to add Container view controller")
        self.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 100, y: 70, width: 600, height: 200)
        self.view.addSubview(viewController.view)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        label.text = "Cache"
        let cacheSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        label.addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: cacheSwitch, attribute: NSLayoutAttribute.Leading, multiplier: 0, constant: 8))
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        cacheSwitch.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views = ["label":label, "switch":cacheSwitch]
        let metrics = ["padding":8]
        viewController.view.addSubview(cacheSwitch)
        viewController.view.addSubview(label)
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-padding-[label]-padding-[switch]->=padding-|", options: nil, metrics: metrics, views: views))
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[label]", options: nil, metrics: metrics, views: views))
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[switch]", options: nil, metrics: metrics, views: views))
//        self.navigationItem.titleView = viewController.view
        viewController.didMoveToParentViewController(self)
        //        self.webCacheViewController = viewController as? WebCacheViewController
    }
    
    //MARK: - Web View
    //MARK: Delegate
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.hidden = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println("Start webpage load.")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        setForwardBackwardButton(webView.canGoForward, canGoBack: webView.canGoBack)
//        var frame: CGRect = webView.frame
//        frame.size.height = 1
//        webView.frame = frame
//        var fittingSize: CGSize = webView.sizeThatFits(CGSizeZero)
//        frame.size = fittingSize
//        webView.frame = frame
//        var rect: CGRect = UIScreen.mainScreen().bounds
//        self.webView.frame = rect
        //println("size: \(fittingSize.width), \(fittingSize.height)")
        println("Finished webpage load.")
    }
    
    //MARK: Methods
    private func setForwardBackwardButton(canGoForward:Bool, canGoBack:Bool){
        if (canGoBack) {
            self.backButton?.enabled = true
        } else {
            self.backButton?.enabled = false
        }
        if (canGoForward) {
            self.forwardButton?.enabled = true
        } else {
            self.forwardButton?.enabled = false
        }
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
