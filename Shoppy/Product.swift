//
//  Product.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import SwiftyJSON

struct Product: Hashable {
    
    let imageURL: URL?
    let name: String
    let price: String
    let pricePerWeight: String
    let weight: String
    
    init?(_ json: JSON) {
        imageURL = URL(string: json["img_url"].string ?? "")
        name = json["name"].string ?? ""
        price = "€\(json["price"].float ?? 0)"
        pricePerWeight = "€4.25/kg"
        weight = "300g"
    }
    
    static func requestProductWithEAN(_ ean: String, completion: @escaping (JSON) -> Void) {
        let url = URL(string: "http://10.100.17.47:5000/products/\(ean)")!
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let json = JSON(data)
            completion(json)
        }
        
        task.resume()
    }
}

func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.name == rhs.name
}
