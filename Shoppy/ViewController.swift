//
//  ViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/23/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import ARKit
import EddystoneScanner
import UIKit

class ViewController: UIViewController, ARSessionDelegate, ProductViewDelegate, RecipeViewDelegate, ScannerDelegate {
    
    var distances: [Int: Int] = [:]
    let distancesNumber = 3
    var updateTimer: Timer!
    
    let scanner = EddystoneScanner.Scanner()
    var beaconList = [Beacon]()
    var matchedPromotions = [ProximityPromotion: Int]()
    
    var export = "minor,rssi,user_id,time\n"
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var productView: ProductView!
    @IBOutlet weak var productViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeView: RecipeView!
    @IBOutlet weak var recipeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Products", bundle: nil) else {
            fatalError()
        }
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "ImageProducts", bundle: nil) else {
            fatalError()
        }
        
        configuration.detectionObjects = referenceObjects
        configuration.detectionImages = referenceImages
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
        
        productView.delegate = self
        recipeView.delegate = self
        
        scanner.startScanning()
        scanner.delegate = self
        
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
        productViewBottomConstraint.constant = -224
        
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
        
        if Cart.shared.products.contains(where: { $0.identifier == "6410381095115" }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
    
    func recipeView(_ recipeView: RecipeView, dismissedWithMessage message: String?) {
        hideRecipeView()
    }
    
    // MARK: - ScannerDelegate
    
    func didFindBeacon(scanner: EddystoneScanner.Scanner, beacon: Beacon) {
        beaconList.append(beacon)
    }
    
    func didLoseBeacon(scanner: EddystoneScanner.Scanner, beacon: Beacon) {
        guard let index = beaconList.index(of: beacon) else {
            return
        }
        
        beaconList.remove(at: index)
    }
    
    func didUpdateBeacon(scanner: EddystoneScanner.Scanner, beacon: Beacon) {
        guard let index = beaconList.index(of: beacon) else {
            beaconList.append(beacon)
            return
        }
        
        distances[beacon.minor] = beacon.rssi
        beaconList[index] = beacon
        
        guard let closestBeacon = beaconList.filter({ $0.minor != -1 }).sorted(by: { $0.accuracy < $1.accuracy }).first else {
            return
        }
        
        DispatchQueue.main.async {
            self.debugLabel.text = String(closestBeacon.minor)
        }
        
        for promotion in ProximityPromotion.promotions {
            if promotion.matches(beacons: beaconList) {
                if matchedPromotions.contains(where: { $0.key == promotion }) {
                    matchedPromotions[promotion] = (matchedPromotions[promotion] ?? 0) + 1
                } else {
                    matchedPromotions[promotion] = 1
                }
            } else {
                matchedPromotions[promotion] = 0
            }
            
            if matchedPromotions[promotion] == 50 {
                DispatchQueue.main.async {
                    self.productView.load(product: promotion.product)
                    self.showProductView()
                }
            }
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {
        let url = URL(string: "http://10.100.47.232:5000/locationdata")!
        var request = URLRequest(url: url)
        request.httpBody = export.data(using: .utf8)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response else {
                return
            }
            
            print(response)
        }
        
        task.resume()
    }
    
    @IBAction func shoppingCartButton(_ sender: Any) {
        performSegue(withIdentifier: "shoppingCartSegue", sender: self)
    }
}
