//
//  UniqueWord.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 21/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

//fix to avoid having to prefix class name with module name
@objc(UniqueWord)

class UniqueWord: NSManagedObject {

    @NSManaged var difficulty: String
    @NSManaged var word: String
    @NSManaged var foreignWord: NSSet

}
