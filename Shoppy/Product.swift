//
//  Product.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import Foundation

struct Product: Hashable {
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
        return Product(imageName: "Ham", modelName: "ham-v2", name: "Peppered Ham", price: "€1.89", pricePerWeight: "€10.50/kg", weight: "180g")
    }
    
    static var orangeJuice: Product {
        return Product(imageName: "Orange Juice", modelName: "orangejuice-v3", name: "Orange Juice", price: "€0.89", pricePerWeight: "€0.85/l", weight: "1l")
    }
    
    static var popcorn: Product {
        return Product(imageName: "Popcorn", modelName: "popcorn-v1", name: "Popcorn", price: "€0.67", pricePerWeight: "€7.44/kg", weight: "90g")
    }
    
    static var froosh: Product {
        return Product(imageName: "Popcorn", modelName: "froosh-v1", name: "Froosh", price: "€1.34", pricePerWeight: "€3.94/kg", weight: "90g")
    }
    
    static var products: [Product] {
        return [.bread, .meat, .orangeJuice, .popcorn, .froosh]
    }
}

func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.name == rhs.name
}
