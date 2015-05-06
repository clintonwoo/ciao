//
//  AppDelegate.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 6/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CoreDataDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    var game: LanguageGame!

    //MARK: - App Delegate
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSUserDefaults.standardUserDefaults().registerDefaults(NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource(ResourceName.UserDefaults.rawValue, ofType: ResourceName.UserDefaults.Type)!)! as [NSObject : AnyObject])
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil))
        UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
        UIApplication.sharedApplication().registerForRemoteNotifications()
        UIApplication.sharedApplication().applicationState // is active, inactive, background?

        // Core Data Delegate protocol implementation
        let initialViewController = self.window!.rootViewController as! UINavigationController
        let menu = initialViewController.topViewController as! MenuViewController
        menu.coreDataDelegate = self
        
        IMFClient.sharedInstance().initializeWithBackendRoute("https://ciao-game.mybluemix.net", backendGUID: "72a02879-45fc-4c33-a31f-3bc64e528468");
        
        IMFAuthorizationManager.sharedInstance().obtainAuthorizationHeaderWithCompletionHandler({
            (response: IMFResponse?, error: NSError?) in
            println(response)
            println(error?.localizedDescription)
        })
        
        IMFLogger.captureUncaughtExceptions()
        IMFLogger.setLogLevel(.Debug)
        IMFAnalytics.sharedInstance().startRecordingApplicationLifecycleEvents()
//        let stack: DefaultCDStack = DefaultCDStack(databasePath: "Model.sqlite", model: managedObjectModel!, automigrating: true)
//        SugarRecord.addStack(stack)
//        SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelVerbose

//        Manager.sharedInstance.request()
        setupCoreData()
        
        if saveContext() {
            return true
        }
        return false
    }
    
    
    // MARK: - Remote notifications
    // Registration callbacks
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //After you call the registerForRemoteNotifications method of the UIApplication object, the app calls this method when device registration completes successfully. In your implementation of this method, connect with your push notification server and give the token to it. APNs pushes notifications only to the device represented by the token.
        //A token that identifies the device to APNs. The token is an opaque data type because that is the form that the provider needs to submit to the APNs servers when it sends a notification to a device. The APNs servers require a binary format for performance reasons.
        // The size of a device token is 32 bytes.
        // Note that the device token is different from the uniqueIdentifier property of UIDevice because, for security and privacy reasons, it must change when the device is wiped.
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // After you call the registerForRemoteNotifications method of the UIApplication object, the app calls this method when there is an error in the registration process.
    }
    // Handlers
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // Tells the delegate that the running app received a remote notification.
        // Implement the application:didReceiveRemoteNotification:fetchCompletionHandler: method instead of this one whenever possible. If your delegate implements both methods, the app object calls the application:didReceiveRemoteNotification:fetchCompletionHandler: method.
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //When a remote notification arrives, the system calls the application:didReceiveRemoteNotification:fetchCompletionHandler: method. Notifications usually signal the availability of new information. In your app delegate method, you might begin downloading new data from a server so that you can update your app’s data structures. You might also use the notification to update your user interface.
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        //When the user taps a custom action in the alert for a remote or local notification’s, the system calls the application:handleActionWithIdentifier:forRemoteNotification:completionHandler: or application:handleActionWithIdentifier:forLocalNotification:completionHandler: method in the background so that your app can perform the associated action.
    }
    
    // MARK: - Local notifications
    // Handler
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // When a local notification fires, the system calls the application:didReceiveLocalNotification: method. The app must be running (or recently launched) to receive this event.
        // Local notifications are similar to remote notifications, but differ in that they are scheduled, displayed, and received entirely on the same device. An app can create and schedule a local notification, and the operating system then delivers it at the scheduled date and time. If the app is not active in the foreground when the notification fires, the system uses the information in the UILocalNotification object to determine whether it should display an alert, badge the app icon, or play a sound. If the app is running in the foreground, the system calls this method directly without alerting the user in any way.
        println("didReceiveLocalNotification")
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        //When the user taps a custom action in the alert for a remote or local notification’s, the system calls the application:handleActionWithIdentifier:forRemoteNotification:completionHandler: or application:handleActionWithIdentifier:forLocalNotification:completionHandler: method in the background so that your app can perform the associated action.
        // The app calls this method when the user taps an action button in an alert displayed in response to a local notification. Local notifications that include a registered category name in their category property display buttons for the actions in that category. If the user taps one of those buttons, the system wakes up the app (launching it if needed) and calls this method in the background. Your implementation of this method should perform the action associated with the specified identifier and execute the block in the completionHandler parameter as soon as you are done. Failure to execute the completion handler block at the end of your implementation will cause your app to be terminated.
    }
    
    // MARK: - User notifications
    // Register
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        //
    }
    
    // MARK: - Continuing User Activities
//    func application(application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: NSError) {
//        <#code#>
//    }
    
    // MARK: - Background Mode
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //For apps that want to initiate background downloads, the system calls the application:performFetchWithCompletionHandler: method when the time is right for you to start those downloads.
        // This method is used to perform a fetch in the background.
        // Use it to fetch notifications and increment the app badge number.
        // Turn on activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println("performFetchWithCompletionHandler")
        UIApplication.sharedApplication().applicationIconBadgeNumber++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        //For apps that use the NSURLSession class to perform background downloads, the system calls the application:handleEventsForBackgroundURLSession:completionHandler: method when those downloads finished while the app was not running. You can use this method to process the downloaded files and update the affected view controllers.
    }


    // MARK: - Application Life Cycle
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        SugarRecord.applicationWillResignActive()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            // Handle if we've taken too long and iOS wants to kill the app
        } // Begin background task that can cancel.
        //Do  long running task
        IMFLogger.send()
        IMFAnalytics.sharedInstance().sendPersistedLogs()
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        SugarRecord.applicationWillEnterForeground()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        SugarRecord.applicationWillTerminate()
    }
    
    //MARK: - Core Data Stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Clinton.Master_Detail" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel? = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
        let url: NSURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Model.sqlite")
        var error: NSError? = nil
        
        if let sourceMetadata: NSDictionary =
            NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(NSSQLiteStoreType,
                URL:url,
                error:&error) {
            var destinationModel  = coordinator?.managedObjectModel
            if (destinationModel?.isConfiguration("Default", compatibleWithStoreMetadata: sourceMetadata as [NSObject : AnyObject]) == nil) {
                //this also returns true if the versions are different but automatic migration can be run
                
                // retrieve the store URL
                //            var storeURL: NSURL = self.managedObjectContext?.persistentStoreCoordinator?.URLForPersistentStore(self.managedObjectContext?.persistentStoreCoordinator?.persistentStores[0] as NSPersistentStore)
                            // lock the current context
                self.managedObjectContext?.lock
                self.managedObjectContext?.reset//to drop pending changes
                
//                for store: NSPersistentStore in coordinator?.persistentStores as [NSPersistentStore] {
                    if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                NSFileManager.defaultManager().removeItemAtURL(url, error: &error)
                        println("Removed database at \(url) \(url.path)")
                    }
//                    coordinator?.removePersistentStore(store: store, error: error)
//                    let pscRemoved: Bool = coordinator?.removePersistentStore(store, error: error) as Bool
//                    if {
//                        println("Removed persistent store.")
//                    } else {
//                        println("Removing persistent store failed. \(error.localizedDescription)")
//                    }
//                   else {
//                    println("Application model is compatible with existing application database.")
//                }

        
                
                //            //delete the store from the current managedObjectContext
//                            if (self.managedObjectContext?.persistentStoreCoordinator?.removePersistentStore(self.managedObjectContext?.persistentStoreCoordinator?.persistentStores.lastObject, error:error))
//                            {
                //                // remove the file containing the data
                //                NSFileManager.defaultManager.removeItemAtURL(storeURL, error: error)
                //                //recreate the store like in the  appDelegate method
                //                self.managedObjectContext?.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: error)
//                            }
                            self.managedObjectContext?.unlock
            }
            //that's it !
        }
       
//            self.managedObjectContext?.reset()
////            for store: NSPersistentStore in coordinator?.persistentStores {
//                if coordinator?.removePersistentStore(coordinator?.persistentStores, error: error) {
//                    println("Removed persistent store.")
//                } else {
//                    println("Removing persistent store failed.")
//                }
////            }
//        } else {
//            println("Application model is compatible with existing application database.")
//        }
        
        var failureReason = "There was an error creating or loading the application's saved data."
        var options = NSDictionary(objectsAndKeys:
            NSNumber(bool: true), NSInferMappingModelAutomaticallyOption,
            NSNumber(bool: true), NSMigratePersistentStoresAutomaticallyOption
        )
        //do lightweight model migration here.
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options as [NSObject : AnyObject], error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        //Nothing happens if automatic migration runs successfully
        return coordinator!
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType)
        return managedObjectContext
        }()
    
    //MARK: - Core Data setup
    
    private func setupCoreData() {
        //create NSmanagedobjects from a plist file and store in persistent store
        var error: NSErrorPointer = nil
        var languageDictionary = NSMutableDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource(ResourceName.Languages.rawValue, ofType: ResourceName.Languages.Type)!)!
        var alphabetDictionary = NSMutableDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource(ResourceName.Alphabet.rawValue, ofType: ResourceName.Alphabet.Type)!)!
        var languageFetchRequest = NSFetchRequest(entityName: Entity.Language)
        var fetchedLanguageObjects = managedObjectContext?.executeFetchRequest(languageFetchRequest, error:error) as! [Language]
        if fetchedLanguageObjects.count == 0 { //No language records found
            for language in languageDictionary { //iterate languages
                var newLanguage = NSEntityDescription.insertNewObjectForEntityForName(Entity.Language, inManagedObjectContext: managedObjectContext!) as! Language
                newLanguage.name = language.key as! String//value.valueForKey("name") as String
                languageDictionary.setObject(newLanguage, forKey:newLanguage.name)
                let languageUpperCharacterArray = alphabetDictionary.valueForKeyPath("\(language.key as! String).uppercase") as! [String] //returns the array of strings
                let languageLowerCharacterArray = alphabetDictionary.valueForKeyPath("\(language.key as! String).lowercase") as! [String]
                for (var i = 0 ; i < languageUpperCharacterArray.count; i++) {
                    var newCharacter = NSEntityDescription.insertNewObjectForEntityForName(Entity.Alphabet, inManagedObjectContext: managedObjectContext!) as! Alphabet
                    newCharacter.uppercase = languageUpperCharacterArray[i]//value.valueForKey("character") as String
                    newCharacter.lowercase = languageLowerCharacterArray[i]
                    newCharacter.index = i
                    newCharacter.language = newLanguage
                    println("Created alphabet character record: \(newCharacter.index) \(newCharacter.uppercase), \(newCharacter.lowercase)")
                }
                println("Created Language record: \(newLanguage.name)")
            }
        }
        var fetchRequest = NSFetchRequest(entityName: Entity.Word)
        var fetchedObjects: NSArray = managedObjectContext?.executeFetchRequest(fetchRequest, error:error) as! [Word]
        if fetchedObjects.count == 0 { //No word records found
            var wordInputArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource(ResourceName.Words.rawValue, ofType:ResourceName.Words.Type)!)!
            for (var i = 0; i < wordInputArray.count; i++) { //iterate over word records
                //create english words
                var englishWord = NSEntityDescription.insertNewObjectForEntityForName(Entity.EnglishWord, inManagedObjectContext: managedObjectContext!) as! EnglishWord
                englishWord.word = wordInputArray[i].valueForKey("word") as! String
                englishWord.difficulty = wordInputArray[i].valueForKey("difficulty") as! String
                englishWord.inPhraseMode = wordInputArray[i].valueForKey("inPhraseMode") as! Bool
                println("Created English word record: \(englishWord.word), \(englishWord.difficulty)")
                for language in NSUserDefaults.standardUserDefaults().stringArrayForKey(UserDefaults.Languages) as! [String] {
                    //create foreign words and relate to languages
                    var word: Word = NSEntityDescription.insertNewObjectForEntityForName(Entity.Word, inManagedObjectContext: managedObjectContext!) as! Word
                    word.word = wordInputArray[i].valueForKey(language) as! String
                    word.englishWord = englishWord
                    word.language = languageDictionary.valueForKey(language) as! Language
                    println("Created Word record: \(word.word)")
                }
            }
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () -> Bool {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
//                return false
                abort()
            }
            return true
        }
        return false
    }
}

