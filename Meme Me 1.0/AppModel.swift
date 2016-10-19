//
//  AppConstants.swift
//  Meme Me 1.0
//
//  Created by SimranJot Singh on 19/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

import UIKit

struct AppModel {
    
    static let defaultTopTextFieldText = "TOP"
    static let defaultBottomTextFieldText = "BOTTOM"
    static let fontsTableViewSegueIdentifier = "fontsTableView"
    static let fontsCellReuseIdentifier = "fontsCell"
    
    struct alert {
        
        static let alertTitle = "Discard"
        static let alertMessage = "Are you sure you want to discard your changes?"
    }
    
    static let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName: UIFont(name: "impact", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
        ] as [String : Any]
    
    
    static let fontsAvailable = UIFont.familyNames
    static var currentFontIndex: Int = -1
    static var selectedFont: String = ""
    
    
    
}
