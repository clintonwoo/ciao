//
//  GameMode.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum GameMode: Int {
    
    case introMode = 0
    case grammarMode = 1
    case alphabetMode = 2
    case phraseMode = 3
    case verbMode = 4
    case dictationMode = 5
    
    init () {
        switch (Foundation.UserDefaults.standard.integer(forKey: UserDefaults.GameMode)) {
            case GameMode.introMode.rawValue:
                self = .introMode
            case GameMode.grammarMode.rawValue:
                self = .grammarMode
            case GameMode.alphabetMode.rawValue:
                self = .alphabetMode
            case GameMode.phraseMode.rawValue:
                self = .phraseMode
            case GameMode.verbMode.rawValue:
                self = .verbMode
            case GameMode.dictationMode.rawValue:
                self = .dictationMode
            default:
                self = .introMode
        }
    }
    
    func toString () -> String {
        switch self {
            case .introMode:
                return "Intro Mode"
            case .grammarMode:
                return "Grammar Mode"
            case .alphabetMode:
                return "Alphabet Mode"
            case .phraseMode:
                return "Phrase Mode"
            case .verbMode:
                return "Verb Mode"
            case .dictationMode:
                return "Dictation Mode"
        }
    }
}
