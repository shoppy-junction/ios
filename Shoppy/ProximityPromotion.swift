//
//  ProximityPromotion.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import SwiftyJSON

struct ProximityPromotion: Hashable {
    
    let beacon: Int
    let name: String
    let product: Product
    
    static var bread: ProximityPromotion {
        return ProximityPromotion(beacon: 12, name: "Bread", product: Product(JSON())!)
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
    
    func matches(distances: [Int: Int]) -> Bool {
        guard let closestBeacon = distances.min(by: { $0.value > $1.value || $1.key == -1 })?.key else {
            return false
        }
        
        return closestBeacon == beacon
    }
}
