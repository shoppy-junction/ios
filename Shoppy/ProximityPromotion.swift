//
//  ProximityPromotion.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import EddystoneScanner

struct ProximityPromotion: Hashable {
    
    let ranges: [Int: [Int]]
    let name: String
    
    static var bread: ProximityPromotion {
        let ranges = [
            13: [-60, 0],
            14: [-75, -50]
        ]
        
        return ProximityPromotion(ranges: ranges, name: "Bread")
    }
    
    static var promotions: [ProximityPromotion] {
        return [.bread]
    }
    
    static func == (lhs: ProximityPromotion, rhs: ProximityPromotion) -> Bool {
        return lhs.name == rhs.name && lhs.ranges == rhs.ranges
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ranges)
        hasher.combine(name)
    }
    
    func matches(beacons: [Beacon]) -> Bool {
        for beacon in beacons {
            guard beacon.minor != -1 else {
                continue
            }
            
            if !ranges.keys.contains(beacon.minor) {
                return false
            }
            
            guard let range = ranges[beacon.minor] else {
                return false
            }
            
            if beacon.rssi < range[0] || beacon.rssi > range[1] {
                return false
            }
        }
        
        return true
    }
}
