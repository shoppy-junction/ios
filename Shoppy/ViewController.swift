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
        guard let productView = Bundle.main.loadNibNamed("ProductView", owner: self, options: nil)?.first as? ProductView else {
            return
        }
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.contentView.addSubview(productView)
        
        visualEffectView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        productView.frame = visualEffectView.bounds
        view.addSubview(productView)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("removed anchor")
    }
}
