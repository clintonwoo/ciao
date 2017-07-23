//
//  LanguageSettingViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 14/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class LanguageSettingViewController: UITableViewController {
    
    //MARK: - Properties
    var game: LanguageGame!
    var delegate: SettingsDelegate!
    var languages = Foundation.UserDefaults.standard.stringArray(forKey: UserDefaults.Languages)!
    
    fileprivate enum Cells {
        static let tvcLanguage = "tvcLanguage"
    }
    
    //MARK: - Initialisers
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localization.Settings.Language
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if ((delegate) != nil){
            delegate?.returnToSource(self, language: game.language)
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let label = tableView.cellForRow(at: indexPath)?.viewWithTag(150) as! UILabel
        game.language = label.text!
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Cells.tvcLanguage, for: indexPath)
        //set the current language with a tick accessory
        if (languages[indexPath.row] == game.language) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        let detailLabel = cell.viewWithTag(150) as! UILabel
        detailLabel.text = languages[indexPath.row] as String
        return cell
    }
    
    //MARK: - Segue
}
