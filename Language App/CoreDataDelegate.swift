//
//  CoreDataDelegate.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataDelegate {
    var applicationDocumentsDirectory: NSURL { mutating get }
    var managedObjectModel: NSManagedObjectModel? { mutating get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? { mutating get }
    var managedObjectContext: NSManagedObjectContext? { mutating get }
    // MARK: Core Data Saving support
    func saveContext () -> Bool
}