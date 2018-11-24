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
        let product = Product(imageURL: "https://public.keskofiles.com/f/k-ruoka/product/6410402003488?w=800&h=500&fm=jpg&q=90&fit=clip&bg=fff", name: "Loaf of Bread", price: "€1.50", pricePerWeight: "€2.50/kg", weight: "300g")
        return ProximityPromotion(beacon: 12, name: "Bread", product: product)
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
        guard let closestBeacon = distances.filter({ $0.key != -1 }).min(by: { $0.value > $1.value })?.key else {
            return false
        }
        
        return closestBeacon == beacon
    }
}
