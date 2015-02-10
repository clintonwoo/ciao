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
    var switchWithTitle: SwitchWithTitle? = nil
    
    //MARK: - Initialisers
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.backButton = UIBarButtonItem(title:"Back", style: UIBarButtonItemStyle.Bordered, target: self.webView, action: "goBack")
        self.forwardButton = UIBarButtonItem(title:"Forward", style: UIBarButtonItemStyle.Bordered, target: self.webView, action: "goForward")
        setForwardBackwardButton(false, canGoBack: false)
        
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
        println("hello")
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
    
    //MARK: - Web view Delegate
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
    
    //MARK: Web view methods
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
