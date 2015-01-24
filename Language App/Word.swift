//
//  Word.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 23/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

//fix to avoid having to prefix class name with module name
@objc(Word)

class Word: NSManagedObject {

    @NSManaged var attempts: NSNumber
    @NSManaged var correctAttempts: NSNumber
    @NSManaged var language: String
    @NSManaged var word: String
    @NSManaged var incorrectAttempts: NSNumber
    @NSManaged var englishWord: UniqueWord

}
