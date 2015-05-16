//
//  EnglishWord.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 26/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import CoreData

//fix to avoid having to prefix class name with module name
@objc(EnglishWord)

class EnglishWord: NSManagedObject {

    @NSManaged var difficulty: String
    @NSManaged var inAlphabetMode: NSNumber
    @NSManaged var inDictactionMode: NSNumber
    @NSManaged var inGrammarMode: NSNumber
    @NSManaged var inPhraseMode: NSNumber
    @NSManaged var inVerbMode: NSNumber
    @NSManaged var word: String
    @NSManaged var foreignWord: NSSet

}
