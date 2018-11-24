//
//  Product.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import Foundation

struct Product {
    let imageName: String
    let modelName: String
    let name: String
    let price: String
    let pricePerWeight: String
    let weight: String
    
    static var bread: Product {
        return Product(imageName: "Bread", modelName: "bread-v1", name: "Loaf of Bread", price: "€1.50", pricePerWeight: "€2.50/kg", weight: "300g")
    }
    
    static var meat: Product {
        return Product(imageName: "Ham", modelName: "ham-v1", name: "Peppered Ham", price: "€1.89", pricePerWeight: "€10.50/kg", weight: "180g")
    }
    
    static var products: [Product] {
        return [.bread, .meat]
    }
}