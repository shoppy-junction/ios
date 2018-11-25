//
//  ChallengeCell.swift
//  Shoppy
//
//  Created by Jack Cook on 11/25/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UIKit

class ChallengeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(challenge: Challenge) {
        titleLabel.text = challenge.name
        descriptionLabel.text = challenge.description
    }
}
