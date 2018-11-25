//
//  WelcomeCell.swift
//  Shoppy
//
//  Created by Jack Cook on 11/25/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UICircularProgressRing
import UICountingLabel
import UIKit

class WelcomeCell: UITableViewCell {
    
    @IBOutlet weak var welcomeLabel: UICountingLabel!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        welcomeLabel.animationDuration = 1
        welcomeLabel.format = "Good morning, Jack! You have %d reward points."
        welcomeLabel.method = .easeInOut
        
        progressRing.maxValue = 500
        progressRing.minValue = 0
        progressRing.innerRingColor = UIColor(red: 76 / 255, green: 209 / 255, blue: 55 / 255, alpha: 1)
        progressRing.innerRingWidth = 8
        progressRing.outerRingWidth = 0
        progressRing.valueIndicator = " points"
    }
    
    func startAnimating() {
        welcomeLabel.count(from: 0, to: 312)
        progressRing.startProgress(to: 312, duration: 1)
    }
}
