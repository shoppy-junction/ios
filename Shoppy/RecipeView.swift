//
//  RecipeView.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UIKit

protocol RecipeViewDelegate {
    func recipeView(_ recipeView: RecipeView, dismissedWithMessage message: String?)
}

class RecipeView: UIVisualEffectView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: RecipeViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func load(recipe: Recipe) {
        descriptionLabel.text = recipe.tip
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        delegate?.recipeView(self, dismissedWithMessage: descriptionLabel.text)
    }
}
