//
//  Language.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 24/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

//fix to avoid having to prefix class name with module name
@objc(Language)

class Language: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var attempts: NSNumber
    @NSManaged var words: NSSet

}
