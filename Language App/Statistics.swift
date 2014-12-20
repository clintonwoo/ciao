//
//  Statistics.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 14/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class Statistics {
    var attempts: Int = 5
    var correctAttempts: Int = 1
    
    init() {
        
    }
    
    var percentageCorrect: Double {
        if (attempts.description.isEmpty) {
            return Double(correctAttempts) / Double(attempts)
        } else {
            return 0
        }
        
    }

}