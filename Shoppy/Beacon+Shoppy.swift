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
    
    var accuracy: Float {
        if rssi == 0 {
            return -1 // if we cannot determine accuracy, return -1.
        }
        
        let ratio = Float(rssi) / Float(txPower)
        
        if ratio < 1 {
            return pow(ratio, 10)
        } else {
            return 0.89976 * pow(ratio, 7.7095) + 0.111
        }
    }
}
