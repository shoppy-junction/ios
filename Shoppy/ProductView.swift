//
//  ProductView.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UIKit

class ProductView: UIVisualEffectView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 8
    }
}
