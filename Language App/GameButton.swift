//
//  GameButton.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 1/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import UIKit

//protocol GameButtonDelegate.. implements target action delegate methods
//protocol GameButtonDataSource.. implements data source methods or computed properties which fetch data from the model
protocol GameButtonDataSource: class {
    func getIntegerData(sender: GameButton) -> Int
}


@IBDesignable
class GameButton: UIButton {
    
    weak var dataSource: GameButtonDataSource? // weak to allow deinitialisation with ref
    @IBInspectable
    var correct: Bool = false
    @IBInspectable
    var gameButtonIndex: Int = 0 //default 0, unused value
    @IBInspectable
    var alphabetGameButton: Bool = false
    
    //let smiliness = dataSource?.getIntegerData(self) ?? 0.0
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
