//
//  GameMode.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum GameMode: Int {
    case IntroMode = 0
    case GrammarMode = 1
    case AlphabetMode = 2
    case PhraseMode = 3
    case VerbMode = 4
    case DictationMode = 5
    
    init () {
        switch (NSUserDefaults.standardUserDefaults().integerForKey(UserDefaults.GameMode)) {
            case GameMode.IntroMode.rawValue:
                self = .IntroMode
            case GameMode.GrammarMode.rawValue:
                self = .GrammarMode
            case GameMode.AlphabetMode.rawValue:
                self = .AlphabetMode
            case GameMode.PhraseMode.rawValue:
                self = .PhraseMode
            case GameMode.VerbMode.rawValue:
                self = .VerbMode
            case GameMode.DictationMode.rawValue:
                self = .DictationMode
            default:
                self = .IntroMode
        }
    }
    
    func toString () -> String {
        switch self {
            case .IntroMode:
                return "Intro Mode"
            case .GrammarMode:
                return "Grammar Mode"
            case .AlphabetMode:
                return "Alphabet Mode"
            case .PhraseMode:
                return "Phrase Mode"
            case .VerbMode:
                return "Verb Mode"
            case .DictationMode:
                return "Dictation Mode"
        }
    }
}
