//
//  AppDelegate.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 6/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: Properties
    var window: UIWindow?
    
    //MARK: App Delegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //        var context: NSManagedObjectContext = self.managedObjectContext!
        //        let initialViewController = self.window!.rootViewController as UINavigationController
        //        let menu = initialViewController.topViewController as MenuViewController
        //        menu.managedObjectContext = self.managedObjectContext
        
        //initialise user defaults
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.registerDefaults(NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Defaults", ofType: "plist")!)!)
        
        //let’s add some more code in there to list out all the objects currently in the database:
        //        var error: NSErrorPointer = nil
        //        var fetchRequest: NSFetchRequest = NSFetchRequest();
        //        if let entity: NSEntityDescription = NSEntityDescription.entityForName("Settings", inManagedObjectContext:context) {
        //            fetchRequest.entity = entity
        //            if var fetchedObjects: NSArray = context.executeFetchRequest(fetchRequest, error:error) {
        //                for object in fetchedObjects {
        //                    println("Difficulty:" , object.valueForKey("difficulty"))
        //                    var string: String = "details"
        //                    //var details: NSManagedObject = object.valueForKey(string)
        //                    println("Has Sound? %@", object.valueForKey("hasSound"))
        //                }
        //            } else { //start creating them if they don't exist
        //                var settings: Settings = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext:context) as Settings
        //                settings.difficulty = "Hard"
        //                settings.hasSound = true
        //                settings.language = "English"
        //            }
        //        }
        
        //Create Statistics table if not exists
        //        if let entity = NSEntityDescription.entityForName("Statistics", inManagedObjectContext:context) {
        //            fetchRequest.entity = entity
        //            if var fetchedObjects: NSArray = context.executeFetchRequest(fetchRequest, error:error) {
        //                //iterate
        //            } else {
        //                var statistics: Statistics = NSEntityDescription.insertNewObjectForEntityForName("Statistics", inManagedObjectContext:context) as Statistics
        //                statistics.attempts = 123
        //                statistics.correctAttempts = 112
        //            }
        //        }
        //        if (!context.save(error)) {
        //            println("Save error.\(error.debugDescription)"); //error.localizedDescription
        //        return false
        //        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data
    
//    lazy var applicationDocumentsDirectory: NSURL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "Clinton.Master_Detail" in the application's documents Application Support directory.
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls[urls.count-1] as NSURL
//        }()
//    
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//        }()
//    
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Model.sqlite")
//        var error: NSError? = nil
//        var failureReason = "There was an error creating or loading the application's saved data."
//        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
//        return coordinator
//        }()
//    
//    lazy var managedObjectContext: NSManagedObjectContext? = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        if coordinator == nil {
//            return nil
//        }
//        var managedObjectContext = NSManagedObjectContext()
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//        }()
    
    // MARK: - Core Data Saving support
    
//    func saveContext () {
//        if let moc = self.managedObjectContext {
//            var error: NSError? = nil
//            if moc.hasChanges && !moc.save(&error) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                NSLog("Unresolved error \(error), \(error!.userInfo)")
//                abort()
//            }
//        }
//    }
}

