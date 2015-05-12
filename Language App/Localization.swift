//
//  Localization.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum Localization {
    
    // Title of navigation bar items
    enum Title {
        static let Modes = NSLocalizedString("ciao-game.title.Modes", comment: "The navigation bar title of the modes screen")
        static let Statistics = NSLocalizedString("ciao-game.title.Statistics", comment: "The navigation bar title of the screen")
        static let Settings = NSLocalizedString("ciao-game.title.Settings", comment: "The navigation bar title of the screen")
        static let About = NSLocalizedString("ciao-game.title.About", comment: "Title of the about screen")
    }
    
    enum Menu {
        static let PlayGame = NSLocalizedString("ciao-game.menu.Play Game", comment: "Menu Play Game button")
        static let ChooseMode = NSLocalizedString("ciao-game.menu.Choose Mode", comment: "Menu Choose Mode button")
        static let Grammar = NSLocalizedString("ciao-game.menu.Grammar", comment: "Menu /Italian etc/Grammar button")
        static let Statistics = NSLocalizedString("ciao-game.menu.Statistics", comment: "Menu Statistics button")
        static let Settings = NSLocalizedString("ciao-game.menu.Settings", comment: "Menu Settings button")
    }
    enum Modes {
    }
    enum Game {
        static let SoundOn = NSLocalizedString("ciao-game.game.Sound On", comment: "Button to turn the game sound on")
        static let SoundOff = NSLocalizedString("ciao-game.game.Sound Off", comment: "Button to turn the game sound off")
    }
    enum Grammar {
        static let Back = NSLocalizedString("ciao-game.grammar.Back", comment: "Back button to browse backwards")
        static let Forward = NSLocalizedString("ciao-game.grammar.Forward", comment: "Forward button to browse forwards in history")
    }
    enum Statistics {
        static let MostSuccessfulWord = NSLocalizedString("ciao-game.statistics.Most Successful Word:", comment: "Statistic label showing the number of words the user has attempted")
        static let MostUnsuccessfulWord = NSLocalizedString("ciao-game.statistics.Most Unsuccessful Word:", comment: "Statistic label showing the number of words the user has attempted")
        static let WordsAttempted = NSLocalizedString("ciao-game.statistics.Words Attempted:", comment: "Statistic label showing the number of words the user has attempted")
        static let CorrectRatio = NSLocalizedString("ciao-game.statistics.Correct Ratio:", comment: "Statistic label showing user's ratio of correct word attempts")
        static let FavouriteLanguage = NSLocalizedString("ciao-game.statistics.Favourite Language:", comment: "User's favourite language")
        static let LongestStreak = NSLocalizedString("ciao-game.statistics.Longest Streak:", comment: "Statistic label showing the user's longest streak")
    }
    enum Settings {
        enum Headers {
            static let GameSettings = NSLocalizedString("ciao-game.settings.headers.Game Settings", comment: "Header title in settings")
            static let Sound = NSLocalizedString("ciao-game.settings.headers.Sound", comment: "Header title in settings")
            static let About = NSLocalizedString("ciao-game.settings.headers.About", comment: "Header title in settings")
        }
        static let Language = NSLocalizedString("ciao-game.settings.Language", comment: "Language setting name in settings")
        static let Difficulty = NSLocalizedString("ciao-game.settings.Difficulty", comment: "Difficulty setting name in settings")
        static let SoundEnabled = NSLocalizedString("ciao-game.settings.Sound Enabled", comment: "Sound enabled setting name in settings")
        static let SpeakingSpeed = NSLocalizedString("ciao-game.settings.Speaking Speed", comment: "Speaking speed setting name in settings")
        static let About = NSLocalizedString("ciao-game.settings.About", comment: "About in settings")
    }
    enum About {
    }
}