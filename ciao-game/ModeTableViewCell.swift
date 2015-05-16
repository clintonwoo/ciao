//
//  ModeTableViewCell.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 26/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import UIKit

@IBDesignable
class ModeTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBInspectable var gameModeIndex: Int = 0 // When optional, key compliant error
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if selected {
//            NSUserDefaults.standardUserDefaults().setValue(self.textLabel?.text, forKey: "gameMode")
//        } else {
//            self.accessoryType = UITableViewCellAccessoryType.None
//        }
//        if (NSUserDefaults.standardUserDefaults().stringForKey("gameMode")) == self.textLabel?.text {
//            self.accessoryType = UITableViewCellAccessoryType.Checkmark
//        } else {
//            self.accessoryType = UITableViewCellAccessoryType.None
//        }
        
//        if selected {
//            self.accessoryType = UITableViewCellAccessoryType.Checkmark
//        } else {
//            self.accessoryType = UITableViewCellAccessoryType.None
//        }
        // Configure the view for the selected state
    }

}
