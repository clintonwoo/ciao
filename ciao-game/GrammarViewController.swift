//
//  GrammarViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 11/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import AFNetworking

class GrammarViewController: UIViewController, UIWebViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
//    @IBOutlet weak var titleView: UIView!
//    @IBOutlet weak var titleSwitch: UISwitch!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    //MARK: - Properties
    let userDefaults = Foundation.UserDefaults.standard
    lazy var willCacheGrammarPages: Bool = {self.userDefaults.bool(forKey: UserDefaults.WillCacheGrammarPages)}()
    var urlRequest: URLRequest?
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    
    //MARK: - Initialisers
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AFNetworkActivityIndicatorManager.shared().decrementActivityCount()
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: - View Controller
    //MARK: Protocol
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
//        webView.st
        self.backButton = UIBarButtonItem(title: Localization.Grammar.Back, style: UIBarButtonItemStyle.plain, target: self.webView, action: #selector(UIWebView.goBack))
        self.forwardButton = UIBarButtonItem(title: Localization.Grammar.Forward, style: UIBarButtonItemStyle.plain, target: self.webView, action: #selector(UIWebView.goForward))
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
    
    override func viewWillAppear(_ animated: Bool) {
        if ((urlRequest) != nil){
//            self.webView.loadRequest(urlRequest!)
            self.webView.loadRequest(urlRequest!,
                progress: { (bytesWritten: UInt, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void in
//                    self.progressView.hidden = false
//                    let tbw = Float(totalBytesWritten)
//                    let tbetw = Float(totalBytesExpectedToWrite)
//                    self.progressView.setProgress(tbw/tbetw, animated: true)
                    return
                },
                success: { (response: HTTPURLResponse!, html: String!) -> String! in
//                    self.progressView.hidden = true
                    return html
                },
                failure: { (error: Error?) -> Void in
                    print()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Container
    func addContainerViewController (_ viewController: UIViewController) {
//        self.addChildViewController(viewController)
        print("Running method to add Container view controller")
        self.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 100, y: 70, width: 600, height: 200)
        self.view.addSubview(viewController.view)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
//        label.text = "Cache"
        let cacheSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        label.addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: cacheSwitch, attribute: NSLayoutAttribute.Leading, multiplier: 0, constant: 8))
        label.translatesAutoresizingMaskIntoConstraints = false
        cacheSwitch.translatesAutoresizingMaskIntoConstraints = false
        let views = ["label":label, "switch":cacheSwitch]
        let metrics = ["padding":8]
        viewController.view.addSubview(cacheSwitch)
        viewController.view.addSubview(label)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-padding-[label]-padding-[switch]->=padding-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[label]", options: .alignAllCenterY, metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[switch]", options: .alignAllCenterY, metrics: metrics, views: views))
//        viewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding-[label]-padding-[switch]->=padding-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metrics, views: views))
//        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[label]", options: nil, metrics: metrics, views: views))
//        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[switch]", options: nil, metrics: metrics, views: views))
//        self.navigationItem.titleView = viewController.view
        viewController.didMove(toParentViewController: self)
        //        self.webCacheViewController = viewController as? WebCacheViewController
    }
    
    //MARK: - Web View
    //MARK: Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
        self.view.bringSubview(toFront: activityIndicator)
        AFNetworkActivityIndicatorManager.shared().incrementActivityCount()
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("Start webpage load.")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        AFNetworkActivityIndicatorManager.shared().decrementActivityCount()
        setForwardBackwardButton(webView.canGoForward, canGoBack: webView.canGoBack)
//        var frame: CGRect = webView.frame
//        frame.size.height = 1
//        webView.frame = frame
//        var fittingSize: CGSize = webView.sizeThatFits(CGSizeZero)
//        frame.size = fittingSize
//        webView.frame = frame
//        var rect: CGRect = UIScreen.mainScreen().bounds
//        self.webView.frame = rect
        //print("size: \(fittingSize.width), \(fittingSize.height)")
        print("Finished webpage load.")
    }
    
    //MARK: Methods
    fileprivate func setForwardBackwardButton(_ canGoForward:Bool, canGoBack:Bool){
        if (canGoBack) {
            self.backButton?.isEnabled = true
        } else {
            self.backButton?.isEnabled = false
        }
        if (canGoForward) {
            self.forwardButton?.isEnabled = true
        } else {
            self.forwardButton?.isEnabled = false
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
