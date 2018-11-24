//
//  Beacon+Shoppy.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import EddystoneScanner

extension Beacon {
    
    var minor: Int {
        if description.starts(with: "7C18") {
            return Int(description.suffix(2)) ?? -1
        } else {
            return -1
        }
    }
}
