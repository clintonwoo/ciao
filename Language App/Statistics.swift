//
//  Statistics.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 2/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

@objc(Statistics)

class Statistics: NSManagedObject {

    @NSManaged var attempts: NSNumber
    @NSManaged var correctAttempts: NSNumber

}
