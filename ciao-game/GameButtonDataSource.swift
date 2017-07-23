//
//  GameButtonDataSource.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 4/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

//protocol GameButtonDelegate.. implements target action delegate methods
//protocol GameButtonDataSource.. implements data source methods or computed properties which fetch data from the model
protocol GameButtonDataSource: class {
    func getIntegerData(_ sender: GameButton) -> Int
}
