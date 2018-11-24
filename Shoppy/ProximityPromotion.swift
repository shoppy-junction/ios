//
//  ProximityPromotion.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import EddystoneScanner

struct ProximityPromotion: Hashable {
    
    let beacon: Int
    let name: String
    let product: Product
    
    static var bread: ProximityPromotion {
        return ProximityPromotion(beacon: 12, name: "Bread", product: .bread)
    }
    
    static var promotions: [ProximityPromotion] {
        return [.bread]
    }
    
    static func == (lhs: ProximityPromotion, rhs: ProximityPromotion) -> Bool {
        return lhs.name == rhs.name && lhs.beacon == rhs.beacon && lhs.product == rhs.product
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(beacon)
        hasher.combine(name)
        hasher.combine(product)
    }
    
    func matches(beacons: [Beacon]) -> Bool {
        guard let closestBeacon = beacons.filter({ $0.minor != -1 }).sorted(by: { $0.rssi > $1.rssi }).first else {
            return false
        }
        
        return closestBeacon.minor == beacon
    }
}
