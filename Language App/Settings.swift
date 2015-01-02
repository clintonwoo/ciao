//
//  Settings.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 2/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

class Settings: NSManagedObject {

    @NSManaged var difficulty: AnyObject
    @NSManaged var hasSound: NSNumber
    @NSManaged var language: AnyObject

}
