//
//  Cart.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import Foundation

class Cart {
    
    var products: [Product] = []
    
    func add(_ product: Product) {
        products.append(product)
    }
    
    func remove(_ product: Product) {
        products.removeAll(where: { $0.name == product.name })
    }
}
