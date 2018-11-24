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
    let modelName: String
    let name: String
    let price: String
    let pricePerWeight: String
    let weight: String
    
    init?(_ json: JSON) {
        guard let result = json["results"].array?.first else {
            return nil
        }
        
        imageURL = URL(string: result["pictureUrls"].array?.first?.dictionary?["original"]?.string ?? "")
        modelName = ""
        name = result["marketingName"].dictionary?["finnish"]?.string ?? ""
        price = "€3.24"
        pricePerWeight = "€4.25/kg"
        weight = "300g"
    }
    
    static func requestProductWithEAN(_ ean: String, completion: @escaping (JSON) -> Void) {
        let url = URL(string: "https://kesko.azure-api.net/v1/search/products")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = [
            "filters": [
                "ean": ean
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("80a29c2c6af54807a3b1c57b6c78e032", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
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
