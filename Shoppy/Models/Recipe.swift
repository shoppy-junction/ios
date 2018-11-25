//
//  Recipe.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import Foundation

class Recipe {
    
    let requirements: [String]
    let tip: String
    var shown = false
    
    static var hamAndCheese = Recipe(requirements: ["6410405108371", "6410402003488"], tip: "If you get some cheese, you can make a ham and cheese sandwich!")
    static var hamAndCheeseShown = false
    
    init(requirements: [String], tip: String) {
        self.requirements = requirements
        self.tip = tip
    }
    
    func shouldDisplay() -> Bool {
        if Recipe.hamAndCheeseShown {
            return false
        }
        
        for requirement in requirements {
            if !Cart.shared.products.contains(where: { $0.identifier == requirement }) {
                return false
            }
        }
        
        return true
    }
}
