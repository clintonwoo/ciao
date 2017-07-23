//
//  AppDelegate.swift
//  ciao-game
//
//  Created by Clinton D'Annolfo on 6/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CoreDataDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    var game: LanguageGame!
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var environment: String! // Development, Production

    //MARK: - Launch
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register User Defaults
        Foundation.UserDefaults.standard.register(defaults: NSDictionary(contentsOfFile: Bundle.main.path(forResource: ResourceName.UserDefaults.rawValue, ofType: ResourceName.UserDefaults.ResourceFileType)!)! as! [AnyHashable : Any] as [AnyHashable: Any] as! [String : Any])
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register iCloud Key Value storage
        Foundation.NotificationCenter.default.addObserver(
            self,
            selector: #selector(AppDelegate.updateKVStoreItems(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default())
        if NSUbiquitousKeyValueStore.default().synchronize() {
            NSLog("Info: iCloud Key Value storage initial sync successful")
        }
        
        // AFNetworking
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        // Register for Local and Remote notifications
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.badge, categories: nil))
        if UIApplication.shared.isRegisteredForRemoteNotifications == true {
            UIApplication.shared.registerForRemoteNotifications()
        }
//        UIApplication.shared.applicationState // is active, inactive, background?

        // Core Data Delegate protocol implementation
        let initialViewController = self.window!.rootViewController as! UINavigationController
        let menu = initialViewController.topViewController as! MenuViewController
        menu.coreDataDelegate = self
        
        //iCloud container for syncing core data. Do not call this method from your app’s main thread. Because this method might take a nontrivial amount of time to set up iCloud and return the requested URL, you should always call it from a secondary thread. To determine if iCloud is available, especially at launch time, check the value of the NSURLRelationship property instead.
        //NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(<#containerIdentifier: String?#>)
        
        IMFClient.sharedInstance().initialize(withBackendRoute: "https://ciao-game.mybluemix.net", backendGUID: "72a02879-45fc-4c33-a31f-3bc64e528468");
        
        IMFAuthorizationManager.sharedInstance().obtainAuthorizationHeader(completionHandler: {
            (response: IMFResponse?, error: Error?) in
            
        })
        
        IMFLogger.captureUncaughtExceptions()
        IMFLogger.setLogLevel(.debug)
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
    
    // MARK: - Application Life Cycle
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        //        SugarRecord.applicationWillResignActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        backgroundTask = UIApplication.shared.beginBackgroundTask (expirationHandler: { () -> Void in
            // Handle if we've taken too long and iOS wants to kill the app
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }) // Begin background task that can cancel.
        DispatchQueue.global(qos: .default).async(execute: {
            //Save your app state before moving to the background. During low-memory conditions, background apps may be purged from memory to free up space. Suspended apps are purged first, and no notice is given to the app before it is purged. As a result, apps should take advantage of the state preservation mechanism in iOS 6 and later t
            // Do the work associated with the task, preferably in chunks.
            //Do  long running task
            //Remove sensitive information from views before moving to the background. When an app transitions to the background, the system takes a snapshot of the app’s main window, which it then presents briefly when transitioning your app back to the foreground. Before returning from your applicationDidEnterBackground: method, you should hide or obscure passwords and other sensitive personal information that might be captured as part of the snapshot.
            IMFLogger.send()
            IMFAnalytics.sharedInstance().sendPersistedLogs()
            // Send any multi device information
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        //        SugarRecord.applicationWillEnterForeground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // And in situations where the system needs to terminate apps to free even more memory, the app calls its delegate’s applicationWillTerminate: method to perform any final tasks before exiting.
        //        SugarRecord.applicationWillTerminate()
    }
    
    // MARK: - Remote notifications
    
    // Registration callbacks
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //After you call the registerForRemoteNotifications method of the UIApplication object, the app calls this method when device registration completes successfully. In your implementation of this method, connect with your push notification server and give the token to it. APNs pushes notifications only to the device represented by the token.
        //A token that identifies the device to APNs. The token is an opaque data type because that is the form that the provider needs to submit to the APNs servers when it sends a notification to a device. The APNs servers require a binary format for performance reasons.
        // The size of a device token is 32 bytes.
        // Note that the device token is different from the uniqueIdentifier property of UIDevice because, for security and privacy reasons, it must change when the device is wiped.
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // After you call the registerForRemoteNotifications method of the UIApplication object, the app calls this method when there is an error in the registration process.
    }
    // Handlers
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Tells the delegate that the running app received a remote notification.
        // Implement the application:didReceiveRemoteNotification:fetchCompletionHandler: method instead of this one whenever possible. If your delegate implements both methods, the app object calls the application:didReceiveRemoteNotification:fetchCompletionHandler: method.
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //When a remote notification arrives, the system calls the application:didReceiveRemoteNotification:fetchCompletionHandler: method. Notifications usually signal the availability of new information. In your app delegate method, you might begin downloading new data from a server so that you can update your app’s data structures. You might also use the notification to update your user interface.
        
        //For a push notification to trigger a download operation, the notification’s payload must include the content-available key with its value set to 1. When that key is present, the system wakes the app in the background (or launches it into the background) and calls the app delegate’s application:didReceiveRemoteNotification:fetchCompletionHandler: method. Your implementation of that method should download the relevant content and integrate it into your app.
        // When downloading any content, it is recommended that you use the NSURLSession class to initiate and manage your downloads.
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        //When the user taps a custom action in the alert for a remote or local notification’s, the system calls the application:handleActionWithIdentifier:forRemoteNotification:completionHandler: or application:handleActionWithIdentifier:forLocalNotification:completionHandler: method in the background so that your app can perform the associated action.
    }
    
    // MARK: - iCloud
    
    func updateKVStoreItems (_ notification: Notification) {
        // Get the list of keys that changed.
        let userInfo: NSDictionary  = notification.userInfo! as NSDictionary
        let reasonForChange = userInfo.object(forKey: NSUbiquitousKeyValueStoreChangeReasonKey) as? NSNumber
//        var reason: Int = -1
        
        // If a reason could not be determined, do not update anything.
        if (reasonForChange == nil) {
            NSLog("Error. Reason for iCloud key value change could not be determined.")
            print("Error.")
            return
        }
        
        func update () {
            // If something is changing externally, get the changes and update the corresponding keys locally.
            let changedKeys = userInfo.object(forKey: NSUbiquitousKeyValueStoreChangedKeysKey) as! [String]
            // This loop assumes you are using the same key names in both the user defaults database and the iCloud key-value store
            for key in changedKeys {
                let value: AnyObject? = NSUbiquitousKeyValueStore.default().object(forKey: key) as AnyObject?
                Foundation.UserDefaults.standard.set(value, forKey:key)
            }
        }
        
        switch (reasonForChange!.intValue) {
        case NSUbiquitousKeyValueStoreServerChange:
            update()
        case NSUbiquitousKeyValueStoreInitialSyncChange:
            update()
        case NSUbiquitousKeyValueStoreQuotaViolationChange:
            NSLog("Error: Your app’s key-value store has exceeded its space quota on the iCloud server.")
        case NSUbiquitousKeyValueStoreAccountChange:
            NSLog("Warn: The user has changed the primary iCloud account. The keys and values in the local key-value store have been replaced with those from the new account, regardless of the relative timestamps.")
        default:
            NSLog("Warn: Unknown reason for iCloud key value update")
        }
    }
    
    // MARK: - Local notifications
    // Handler
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // When a local notification fires, the system calls the application:didReceiveLocalNotification: method. The app must be running (or recently launched) to receive this event.
        // Local notifications are similar to remote notifications, but differ in that they are scheduled, displayed, and received entirely on the same device. An app can create and schedule a local notification, and the operating system then delivers it at the scheduled date and time. If the app is not active in the foreground when the notification fires, the system uses the information in the UILocalNotification object to determine whether it should display an alert, badge the app icon, or play a sound. If the app is running in the foreground, the system calls this method directly without alerting the user in any way.
        print("didReceiveLocalNotification")
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        //When the user taps a custom action in the alert for a remote or local notification’s, the system calls the application:handleActionWithIdentifier:forRemoteNotification:completionHandler: or application:handleActionWithIdentifier:forLocalNotification:completionHandler: method in the background so that your app can perform the associated action.
        // The app calls this method when the user taps an action button in an alert displayed in response to a local notification. Local notifications that include a registered category name in their category property display buttons for the actions in that category. If the user taps one of those buttons, the system wakes up the app (launching it if needed) and calls this method in the background. Your implementation of this method should perform the action associated with the specified identifier and execute the block in the completionHandler parameter as soon as you are done. Failure to execute the completion handler block at the end of your implementation will cause your app to be terminated.
    }
    
    // MARK: - User notifications
    // Register
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //
    }
    
    // MARK: - Continuing User Activities
//    func application(application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: NSError) {
//        <#code#>
//    }
    
    // MARK: - Background Mode
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //For apps that want to initiate background downloads, the system calls the application:performFetchWithCompletionHandler: method when the time is right for you to start those downloads.
        // This method is used to perform a fetch in the background.
        // Use it to fetch notifications and increment the app badge number.
        // Turn on activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("performFetchWithCompletionHandler")
        UIApplication.shared.applicationIconBadgeNumber += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //As soon as you finish downloading the new content, you must execute the provided completion handler block, passing a result that indicates whether content was available. Executing this block tells the system that it can move your app back to the suspended state and evaluate its power usage. Apps that download small amounts of content quickly, and accurately reflect when they had content available to download, are more likely to receive execution time in the future than apps that take a long time to download their content or that claim content was available but then do not download anything.
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        //For apps that use the NSURLSession class to perform background downloads, the system calls the application:handleEventsForBackgroundURLSession:completionHandler: method when those downloads finished while the app was not running. You can use this method to process the downloaded files and update the affected view controllers.
    }

    //MARK: - Core Data Stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Clinton.Master_Detail" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel? = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
        let url: URL = self.applicationDocumentsDirectory.appendingPathComponent("Model.sqlite")
        
        do {
            let sourceMetadata =
                try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType,
                                                                            at:url)
            var destinationModel  = coordinator?.managedObjectModel
            if (destinationModel?.isConfiguration(withName: "Default",
                                                  compatibleWithStoreMetadata: sourceMetadata) == nil) {
                //this also returns true if the versions are different but automatic migration can be run
                
                // retrieve the store URL
                //            var storeURL: NSURL = self.managedObjectContext?.persistentStoreCoordinator?.URLForPersistentStore(self.managedObjectContext?.persistentStoreCoordinator?.persistentStores[0] as NSPersistentStore)
                // lock the current context
                // self.managedObjectContext?.lock()
                // self.managedObjectContext?.reset()//to drop pending changes
                
                //                for store: NSPersistentStore in coordinator?.persistentStores as [NSPersistentStore] {
                if FileManager.default.fileExists(atPath: url.path) {
                    do {
                        try FileManager.default.removeItem(at: url)
                    } catch {
                        print(error)
                    }
                    print("Removed database at \(url) \(url.path)")
                }
                //                    coordinator?.removePersistentStore(store: store, error: error)
                //                    let pscRemoved: Bool = coordinator?.removePersistentStore(store, error: error) as Bool
                //                    if {
                //                        print("Removed persistent store.")
                //                    } else {
                //                        print("Removing persistent store failed. \(error.localizedDescription)")
                //                    }
                //                   else {
                //                    print("Application model is compatible with existing application database.")
                //                }
                
                
                
                //            //delete the store from the current managedObjectContext
                //                            if (self.managedObjectContext?.persistentStoreCoordinator?.removePersistentStore(self.managedObjectContext?.persistentStoreCoordinator?.persistentStores.lastObject, error:error))
                //                            {
                //                // remove the file containing the data
                //                NSFileManager.defaultManager.removeItemAtURL(storeURL, error: error)
                //                //recreate the store like in the  appDelegate method
                //                self.managedObjectContext?.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: error)
                //                            }
//                self.managedObjectContext?.unlock()
            }
        } catch {
            print(error)
        }
        
//        if let sourceMetadata: NSDictionary =
//            NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType,
//                                                                    at:url) as NSDictionary? {
//            var destinationModel  = coordinator?.managedObjectModel
//            if (destinationModel?.isConfiguration("Default", compatibleWithStoreMetadata: sourceMetadata as [AnyHashable: Any]) == nil) {
//                //this also returns true if the versions are different but automatic migration can be run
//                
//                // retrieve the store URL
//                //            var storeURL: NSURL = self.managedObjectContext?.persistentStoreCoordinator?.URLForPersistentStore(self.managedObjectContext?.persistentStoreCoordinator?.persistentStores[0] as NSPersistentStore)
//                            // lock the current context
//                self.managedObjectContext?.lock()
//                self.managedObjectContext?.reset()//to drop pending changes
//                
////                for store: NSPersistentStore in coordinator?.persistentStores as [NSPersistentStore] {
//                    if FileManager.default.fileExists(atPath: url.path) {
//                        do {
//                            try FileManager.default.removeItem(at: url)
//                        } catch {
//                            print(error)
//                        }
//                        print("Removed database at \(url) \(url.path)")
//                    }
////                    coordinator?.removePersistentStore(store: store, error: error)
////                    let pscRemoved: Bool = coordinator?.removePersistentStore(store, error: error) as Bool
////                    if {
////                        print("Removed persistent store.")
////                    } else {
////                        print("Removing persistent store failed. \(error.localizedDescription)")
////                    }
////                   else {
////                    print("Application model is compatible with existing application database.")
////                }
//
//        
//                
//                //            //delete the store from the current managedObjectContext
////                            if (self.managedObjectContext?.persistentStoreCoordinator?.removePersistentStore(self.managedObjectContext?.persistentStoreCoordinator?.persistentStores.lastObject, error:error))
////                            {
//                //                // remove the file containing the data
//                //                NSFileManager.defaultManager.removeItemAtURL(storeURL, error: error)
//                //                //recreate the store like in the  appDelegate method
//                //                self.managedObjectContext?.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: error)
////                            }
//                            self.managedObjectContext?.unlock()
//            }
            //that's it !
//        }
       
//            self.managedObjectContext?.reset()
////            for store: NSPersistentStore in coordinator?.persistentStores {
//                if coordinator?.removePersistentStore(coordinator?.persistentStores, error: error) {
//                    print("Removed persistent store.")
//                } else {
//                    print("Removing persistent store failed.")
//                }
////            }
//        } else {
//            print("Application model is compatible with existing application database.")
//        }
        
        var failureReason = "There was an error creating or loading the application's saved data."
//        var options = NSDictionary(
////            NSInferMappingModelAutomaticallyOption,
//            dictionaryLiteral: true, NSInferMappingModelAutomaticallyOption,
//            //NSNumber(bool: true), NSInferMappingModelAutomaticallyOption,
//            NSNumber(value: true), NSMigratePersistentStoresAutomaticallyOption
//        )
        //do lightweight model migration here.
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            
            //Nothing happens if automatic migration runs successfully
            return coordinator!
        } catch {
            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
//            dict[NSUnderlyingErrorKey] = error
//            
//            var error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(String(describing: error)), \(error.userInfo)")
            print(error)
            abort()
        }
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        return managedObjectContext
        }()
    
    //MARK: - Core Data setup
    
    fileprivate func setupCoreData() {
        //create NSmanagedobjects from a plist file and store in persistent store
//        var error: NSErrorPointer? = nil
        let languageDictionary = NSMutableDictionary(contentsOfFile: Bundle.main.path(forResource: ResourceName.Languages.rawValue, ofType: ResourceName.Languages.ResourceFileType)!)!
        let alphabetDictionary = NSMutableDictionary(contentsOfFile: Bundle.main.path(forResource: ResourceName.Alphabet.rawValue, ofType: ResourceName.Alphabet.ResourceFileType)!)!
        let languageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Language)
        var fetchedLanguageObjects: [Language]
        do {
            fetchedLanguageObjects = try managedObjectContext?.fetch(languageFetchRequest) as! [Language]
            if fetchedLanguageObjects.count == 0 { //No language records found
                for language in languageDictionary { //iterate languages
                    let newLanguage = NSEntityDescription.insertNewObject(forEntityName: Entity.Language, into: managedObjectContext!) as! Language
                    newLanguage.name = language.key as! String//value.valueForKey("name") as String
                    languageDictionary.setObject(newLanguage, forKey:newLanguage.name as NSCopying)
                    let languageUpperCharacterArray = alphabetDictionary.value(forKeyPath: "\(language.key as! String).uppercase") as! [String] //returns the array of strings
                    let languageLowerCharacterArray = alphabetDictionary.value(forKeyPath: "\(language.key as! String).lowercase") as! [String]
                    for i in 0..<languageUpperCharacterArray.count {
                        let newCharacter = NSEntityDescription.insertNewObject(forEntityName: Entity.Alphabet, into: managedObjectContext!) as! Alphabet
                        newCharacter.uppercase = languageUpperCharacterArray[i]//value.valueForKey("character") as String
                        newCharacter.lowercase = languageLowerCharacterArray[i]
                        //                    newCharacter.index = NSNumber(i)
                        newCharacter.index = NSNumber(value: i)
                        newCharacter.language = newLanguage
                        print("Created alphabet character record: \(newCharacter.index) \(newCharacter.uppercase), \(newCharacter.lowercase)")
                    }
                    print("Created Language record: \(newLanguage.name)")
                }
            }

        } catch {
            print(error)
        }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Word)
        var fetchedObjects: [Word]
        do {
            fetchedObjects = try managedObjectContext?.fetch(fetchRequest) as! [Word]
            if fetchedObjects.count == 0 { //No word records found
                var wordInputArray: [Dictionary] = NSArray(contentsOfFile: Bundle.main.path(forResource: ResourceName.Words.rawValue, ofType:ResourceName.Words.ResourceFileType)!)! as! [Dictionary<String, Any>]
                for i in 0..<wordInputArray.count { //iterate over word records
                    //create english words
                    let englishWord = NSEntityDescription.insertNewObject(forEntityName: Entity.EnglishWord, into: managedObjectContext!) as! EnglishWord
                    englishWord.word = wordInputArray[i]["word"] as! String
                    englishWord.difficulty = (wordInputArray[i] as AnyObject).value(forKey: "difficulty") as! String
                    print("inphrasemode")
                    print(wordInputArray[i]["inPhraseMode"]!)
                    englishWord.inPhraseMode = wordInputArray[i]["inPhraseMode"] as! NSNumber
                    print("Created English word record: \(englishWord.word), \(englishWord.difficulty)")
                    for language in Foundation.UserDefaults.standard.stringArray(forKey: UserDefaults.Languages)! {
                        //create foreign words and relate to languages
                        let word: Word = NSEntityDescription.insertNewObject(forEntityName: Entity.Word, into: managedObjectContext!) as! Word
                        word.word = wordInputArray[i][language]! as! String
                        word.englishWord = englishWord
                        word.language = languageDictionary.value(forKey: language) as! Language
                        print("Created Word record: \(word.word)")
                    }
                }
            }

        } catch {
            print(error)
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () -> Bool {
        if let moc = self.managedObjectContext {
//            var error: NSError? = nil
            do {
                try moc.save()
            } catch {
                print("Managed Object Context Save failed: \(error)")
            }
//            if moc.hasChanges && try moc.save() {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                NSLog("Unresolved error \(error), \(error!.userInfo)")
//                return false
//                abort()
//            }
            return true
        }
        return false
    }
}

