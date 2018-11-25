//
//  CartViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/24/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shopping Cart"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else {
            fatalError()
        }
        
        let product = Cart.shared.products[indexPath.row]
        cell.thumbnailView.kf.setImage(with: product.imageURL)
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.price
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CartCell.height
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func checkoutButton(_ sender: Any) {
        
    }
}
