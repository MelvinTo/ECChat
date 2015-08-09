//
//  LoginServiceCellViewController.swift
//  Pods
//
//  Created by Melvin Tu on 7/25/15.
//
//

import Foundation

class LoginServiceCell : UICollectionViewCell {
    
    @IBOutlet weak var serviceButton: UIButton!
    
    var title = "cell"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSLog("test")
    }
}