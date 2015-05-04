//
//  GameMode.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum GameMode {
    case IntroMode
    case GrammarMode
    case AlphabetMode
    case PhraseMode
    case VerbMode
    case DictationMode
    
    init () {
        switch (NSUserDefaults.standardUserDefaults().stringForKey(UserDefaults.GameMode)!) {
            case GameMode.IntroMode.toString():
                self = .IntroMode
            case GameMode.GrammarMode.toString():
                self = .GrammarMode
            case GameMode.AlphabetMode.toString():
                self = .AlphabetMode
            case GameMode.PhraseMode.toString():
                self = .PhraseMode
            case GameMode.VerbMode.toString():
                self = .VerbMode
            case GameMode.DictationMode.toString():
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
