//
//  BeaconInfo+Shoppy.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import Foundation

extension BeaconInfo {
    
    var minor: Int {
        let description = beaconID.description.split(separator: " ")[2]
        
        if description.starts(with: "7c18") {
            return Int(description.suffix(2)) ?? -1
        } else {
            return -1
        }
    }
}
