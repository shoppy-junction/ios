//
//  ProductView.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import Kingfisher
import UIKit

protocol ProductViewDelegate {
    func productView(_ productView: ProductView, addedProductToCart product: Product)
    func productView(_ productView: ProductView, dismissedWithProduct product: Product?)
}

class ProductView: UIVisualEffectView {
    
    var delegate: ProductViewDelegate?
    var product: Product?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pricePerWeightLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 8
        
        addToCartButton.backgroundColor = addToCartButton.tintColor
        addToCartButton.layer.cornerRadius = 4
        addToCartButton.setTitleColor(.white, for: .normal)
    }
    
    func load(product: Product) {
        self.product = product
        
        if let url = product.imageURL {
            imageView.kf.setImage(with: url)
        }
        
        nameLabel.text = product.name
        weightLabel.text = product.weight
        priceLabel.text = product.price
        pricePerWeightLabel.text = product.pricePerWeight
    }
    
    @IBAction func addedToCart(_ sender: UIButton) {
        guard let product = product else {
            return
        }
        
        delegate?.productView(self, addedProductToCart: product)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        delegate?.productView(self, dismissedWithProduct: product)
    }
}
