//
//  SwitchWithTitle.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 11/01/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//
//  Used on Web View as a title to set a caching behaviour

import UIKit

class SwitchWithTitle: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var switchView = UISwitch()
    var label = UILabel()
    
    required init(_ title: String, on: Bool) {
        switchView.on = on
        label.text = title
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}
