//
//  Alphabet.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 26/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

@objc(Alphabet)

class Alphabet: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var uppercase: String
    @NSManaged var lowercase: String
    @NSManaged var language: Language

}
