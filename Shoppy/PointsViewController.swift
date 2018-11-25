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

class PointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = (
        [
            Challenge(name: "Sustainability Pledge", description: "Buy 10 eco-friendly products this week"),
            Challenge(name: "November Challenge", description: "Gain 100 points")
        ],
        [
            Challenge(name: "October Challenge", description: "Gain 50 points"),
            Challenge(name: "Red Cross Day", description: "Donate to the Red Cross on 5/8!")
        ]
    )
    
    private var welcomeCell: WelcomeCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Reward Points"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        welcomeCell?.startAnimating()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return dataSource.0.count
        case 2:
            return dataSource.1.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell", for: indexPath) as? WelcomeCell else {
                fatalError()
            }
            
            welcomeCell = cell
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as? ChallengeCell else {
                fatalError()
            }
            
            cell.configure(challenge: dataSource.0[indexPath.row])
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as? ChallengeCell else {
                fatalError()
            }
            
            cell.configure(challenge: dataSource.1[indexPath.row])
            return cell
        default:
            fatalError()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 409
        default:
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Current Challenges"
        case 2:
            return "Completed Challenges"
        default:
            return nil
        }
    }
}
