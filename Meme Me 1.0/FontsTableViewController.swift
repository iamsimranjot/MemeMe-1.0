//
//  FontsTableViewController.swift
//  Meme Me 1.0
//
//  Created by SimranJot Singh on 19/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

import UIKit

class FontsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    let fontData = AppModel.fontsAvailable

    
    //MARK: LifeCycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fontData.count
    }

    
    //MARK: Table View Delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppModel.fontsCellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = fontData[indexPath.row]
        cell.textLabel?.font = UIFont(name: fontData[indexPath.row], size: 20)
        
        if indexPath.row == AppModel.currentFontIndex {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppModel.currentFontIndex = indexPath.row
        AppModel.selectedFont = fontData[indexPath.row]
        tableView.reloadData()
        
    }

}
