//
//  Static.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum StoryboardName {
    static let FirstRun = "FirstRun"
}

enum StoryboardID {
    static let Login = "Login"
    static let Tutorial = "Tutorial"
    static let TutorialNavigationVC = "TutorialNavigationViewController"
    static let TutorialPageVC = "TutorialPageViewController"
}

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
    static let WillCacheGrammarPages = "willCacheGrammarPages"
    
    static let FirstRun = "firstRun"
    static let isUserLoggedIn = "isUserLoggedIn"
}

enum ImageName {
    static let TutorialImages = ["Twitter Logo", "LinkedIn Logo", "Twitter Logo", "LinkedIn Logo", "Twitter Logo"]
    
}

enum NotificationCenter {
    static let LongestStreakChanged = "LongestStreakChanged"
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
    
    var ResourceFileType: String {
        switch self {
        case .UserDefaults:
            return "plist"
        case .WikipediaGrammarURL:
            return "strings"
        case .WikipediaOrthography:
            return "strings"
        case .IETFLanguageCode:
            return "strings"
        case .Words:
            return "plist"
        case .Languages:
            return "plist"
        case .Alphabet:
            return "plist"
        }
    }
}
