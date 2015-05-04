//
//  Static.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum UserDefaults {
    static let Attempts = "attempts"
    static let CorrectAttempts = "corectAttempts"
    static let Language = "language"
    static let Languages = "languages"
    static let Difficulty = "difficulty"
    static let GameMode = "gameMode"
    static let LongestStreak = "longestStreak"
    static let HasSound = "hasSound"
    static let SpeakingSpeed = "speakingSpeed"
}

enum Entity {
    static let Language = "Language"
    static let Word = "Word"
    static let EnglishWord = "EnglishWord"
    static let Alphabet = "Alphabet"
}

enum ResourceName: String {
    case UserDefaults = "UserDefaults"
    case WikipediaGrammarURL = "WikipediaGrammarURL"
    case WikipediaOrthography = "WikipediaOrthography"
    case IETFLanguageCode = "IETFLanguageCode"
    case Words = "Words"
    case Languages = "Languages"
    case Alphabet = "Alphabet"
    
    var Type: String {
        switch self {
        case UserDefaults:
            return "plist"
        case WikipediaGrammarURL:
            return "strings"
        case WikipediaOrthography:
            return "strings"
        case IETFLanguageCode:
            return "strings"
        case Words:
            return "plist"
        case Languages:
            return "plist"
        case Alphabet:
            return "plist"
        }
    }
}

//enum SegueID {
//    
//}

