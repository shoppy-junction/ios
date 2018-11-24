//
//  ViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/23/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import ARKit
import UIKit

class ViewController: UIViewController, ARSessionDelegate, ProductViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var productView: ProductView!
    @IBOutlet weak var productViewBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Products", bundle: nil) else {
            fatalError()
        }
        
        configuration.detectionObjects = referenceObjects
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
        
        productView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let name = anchors.first?.name, let product = Product.products.first(where: { $0.modelName == name }) else {
            return
        }
        
        productView.load(product: product)
        
        productViewBottomConstraint.constant = 16
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("removed anchor")
    }
    
    // MARK: - ProductViewDelegate
    
    func productView(_ productView: ProductView, addedProductToCart product: Product) {
        productViewBottomConstraint.constant = -224
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        guard let frame = sceneView.session.currentFrame else {
            return
        }
        
        for anchor in frame.anchors {
            sceneView.session.remove(anchor: anchor)
        }
    }
}
