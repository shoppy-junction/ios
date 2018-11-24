//
//  PointsViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/25/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UICircularProgressRing
import UICountingLabel
import UIKit

class PointsViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UICountingLabel!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.animationDuration = 1
        welcomeLabel.format = "Good morning, Jack! You have %d reward points."
        welcomeLabel.method = .easeInOut
        
        progressRing.maxValue = 500
        progressRing.minValue = 0
        progressRing.innerRingColor = UIButton().tintColor
        progressRing.innerRingWidth = 8
        progressRing.outerRingWidth = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        welcomeLabel.count(from: 0, to: 312)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressRing.startProgress(to: 312, duration: 1)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
