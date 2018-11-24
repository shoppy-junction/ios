//
//  ViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/23/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import ARKit
import UIKit

class ViewController: UIViewController, ARSessionDelegate {
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print(anchors)
        productViewBottomConstraint.constant = 16
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("removed anchor")
    }
}
