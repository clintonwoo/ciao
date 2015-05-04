//
//  Localization.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

enum Localization {
    
    enum Menu {
        static let Grammar = NSLocalizedString("Grammar", comment: "Show wikipedia grammar page button on menu")
    }
    enum Game {
        static let SoundOn = NSLocalizedString("Sound On", comment: "Button to turn the game sound on")
        static let SoundOff = NSLocalizedString("Sound Off", comment: "Button to turn the game sound off")
    }
    enum Grammar {
        static let Back = NSLocalizedString("Back", comment: "Back button to browse backwards")
        static let Forward = NSLocalizedString("Forward", comment: "Forward button to browse forwards in history")
    }
    enum Statistics {
        static let MostSuccessfulWord = NSLocalizedString("Most Successful Word:", comment: "Statistic label showing the number of words the user has attempted")
        static let MostUnsuccessfulWord = NSLocalizedString("Most Unsuccessful Word:", comment: "Statistic label showing the number of words the user has attempted")
        static let WordsAttempted = NSLocalizedString("Words Attempted:", comment: "Statistic label showing the number of words the user has attempted")
        static let CorrectRatio = NSLocalizedString("Correct Ratio:", comment: "Statistic label showing user's ratio of correct word attempts")
        static let FavouriteLanguage = NSLocalizedString("Favourite Language:", comment: "User's favourite language")
        static let LongestStreak = NSLocalizedString("Longest Streak:", comment: "Statistic label showing the user's longest streak")
    }
    enum Settings {
        static let GameSettings = NSLocalizedString("Game Settings", comment: "Header title in settings")
        static let Sound = NSLocalizedString("Sound", comment: "Header title in settings")
        static let About = NSLocalizedString("About", comment: "Header title in settings")
    }
}