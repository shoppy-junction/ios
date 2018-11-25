//
//  CloseButton.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UIKit

class CloseButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor(white: 0, alpha: 0.25)
        layer.cornerRadius = 8
        tintColor = UIColor(white: 0, alpha: 0.5)
    }
}
