//
//  ProximityPromotion.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import SwiftyJSON

struct ProximityPromotion {
    
    let beacon: Int
    let name: String
    let product: Product
    
    static var bread: ProximityPromotion {
        let product = Product(identifier: "6410402003488", imageURL: "https://public.keskofiles.com/f/k-ruoka/product/6410402003488?w=800&h=500&fm=jpg&q=90&fit=clip&bg=fff", name: "Loaf of Bread", price: "€1.50", pricePerWeight: "€2.50/kg", weight: "300g", recommendation: "Gluten-Free Bread")
        return ProximityPromotion(beacon: 13, name: "Bread", product: product)
    }
    
    static var promotions: [ProximityPromotion] {
        return [.bread]
    }
    
    func matches(distances: [Int: Int]) -> Bool {
        guard let closestBeacon = distances.filter({ $0.key != -1 }).min(by: { $0.value > $1.value })?.key else {
            return false
        }
        
        return closestBeacon == beacon
    }
}
