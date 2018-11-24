//
//  ViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/23/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import ARKit
import CoreBluetooth
import UIKit

class ViewController: UIViewController, ARSessionDelegate, CBCentralManagerDelegate, ProductViewDelegate {
    
    var bluetoothManager: CBCentralManager!
    var distances: [String: (String, Int)] = [:]
    let distancesNumber = 5
    var updateTimer: Timer!
    
    var export = "uuid,name,rssi\n"
    
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
        
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        bluetoothManager.delegate = self
        
        updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(saveBluetoothData), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func saveBluetoothData() {
        guard distances.count >= distancesNumber else {
            return
        }
        
        var lines = distances.map { (key: String, value: (String, Int)) -> [String] in
            return [key, value.0, String(value.1)]
        }
        
        lines.sort(by: { $0[2] < $1[2] })
        lines = lines.prefix(upTo: distancesNumber).map({ $0 })
        
        for line in lines {
            export += "\(line[0]),\(line[1]),\(line[2])\n"
        }
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
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            bluetoothManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else {
            return
        }
        
        distances[peripheral.identifier.uuidString] = (name, RSSI.intValue)
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
        
        print(export)
    }
}
