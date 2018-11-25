//
//  ViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/23/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import ARKit
import SafariServices
import UIKit

class ViewController: UIViewController, ARSessionDelegate, ProductViewDelegate, RecipeViewDelegate, BeaconScannerDelegate {
    
    var distances: [Int: Int] = [:]
    let distancesNumber = 3
    var updateTimer: Timer!
    
    var beaconScanner: BeaconScanner!
    var matchedPromotions = [String: Int]()
    
    var export = "minor,rssi,user_id,time\n"
    var purchaseExport = "time,user_id,ean,price\n"
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var productView: ProductView!
    @IBOutlet weak var productViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeView: RecipeView!
    @IBOutlet weak var recipeViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "ImageProducts", bundle: nil) else {
            fatalError()
        }
        
        configuration.detectionImages = referenceImages
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
        
        productView.delegate = self
        recipeView.delegate = self
        
        beaconScanner = BeaconScanner()
        beaconScanner.delegate = self
        beaconScanner.startScanning()
        
        updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(saveBluetoothData), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func saveBluetoothData() {
        guard distances.count >= distancesNumber + 1 else {
            return
        }
        
        var lines = [[Int]]()
        
        for (key, value) in distances {
            guard key != -1 else {
                continue
            }
            
            lines.append([key, value])
        }
        
        lines.sort(by: { $0[1] < $1[1] })
        lines = lines.prefix(upTo: distancesNumber).map({ $0 })
        
        for line in lines {
            export += "\(line[0]),\(line[1]),0,\(Date().timeIntervalSince1970)\n"
        }
    }
    
    func hideProductView() {
        productViewBottomConstraint.constant = -304
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showProductView() {
        productViewBottomConstraint.constant = 16
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideRecipeView() {
        recipeViewBottomConstraint.constant = -192
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showRecipeView() {
        guard productViewBottomConstraint.constant != 16 else {
            return
        }
        
        recipeViewBottomConstraint.constant = 16
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(camera.trackingState)
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard recipeViewBottomConstraint.constant != 16 else {
            for anchor in anchors {
                session.remove(anchor: anchor)
            }
            
            return
        }
        
        guard let ean = anchors.first?.name else {
            return
        }
        
        Product.requestProductWithEAN(ean) { (json) in
            guard let product = Product(json) else {
                return
            }
            
            DispatchQueue.main.async {
                self.productView.load(product: product)
                self.showProductView()
            }
        }
    }
    
    // MARK: - ProductViewDelegate
    
    func productView(_ productView: ProductView, addedProductToCart product: Product) {
        hideProductView()
        
        Cart.shared.add(product)
        purchaseExport += "\(Date().timeIntervalSince1970),0,\(product.identifier),\(product.price)\n"
        
        if Recipe.hamAndCheese.shouldDisplay() {
            Recipe.hamAndCheeseShown = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.recipeView.load(recipe: Recipe.hamAndCheese)
                self.showRecipeView()
            }
        }
        
        guard let frame = sceneView.session.currentFrame else {
            return
        }

        for anchor in frame.anchors {
            sceneView.session.remove(anchor: anchor)
        }
    }
    
    func productView(_ productView: ProductView, dismissedWithProduct product: Product?) {
        hideProductView()
        
        guard let frame = sceneView.session.currentFrame else {
            return
        }
        
        for anchor in frame.anchors {
            sceneView.session.remove(anchor: anchor)
        }
    }
    
    // MARK: - RecipeViewDelegate
    
    func recipeView(_ recipeView: RecipeView, willViewRecipe recipe: Recipe) {
        let url = URL(string: "https://www.k-ruoka.fi/reseptit/vohvelisandwich")!
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true)
        
        hideRecipeView()
    }
    
    func recipeView(_ recipeView: RecipeView, dismissedWithMessage message: String?) {
        hideRecipeView()
    }
    
    // MARK: - BeaconScannerDelegate
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        // found beacon
    }
    
    func didLoseBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        // lost beacon
    }
    
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        distances[beaconInfo.minor] = beaconInfo.RSSI
        
        for promotion in ProximityPromotion.promotions {
            if promotion.matches(distances: distances) {
                if matchedPromotions.contains(where: { $0.key == promotion.product.identifier }) {
                    matchedPromotions[promotion.product.identifier] = (matchedPromotions[promotion.product.identifier] ?? 0) + 1
                } else {
                    matchedPromotions[promotion.product.identifier] = 1
                }
            } else {
                matchedPromotions[promotion.product.identifier] = 0
            }
            
            if matchedPromotions[promotion.product.identifier] == 50 {
                DispatchQueue.main.async {
                    self.productView.load(product: promotion.product)
                    self.showProductView()
                }
            }
        }
    }
    
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {
        // observed URL
    }
}
