//
//  ViewController.swift
//  Shoppy
//
//  Created by Jack Cook on 11/23/18.
//  Copyright © 2018 Jack Cook. All rights reserved.
//

import CoreLocation
import SceneKit

class ViewController: UIViewController, CLLocationManagerDelegate, SceneLocationViewDelegate {
    
    let locationManager = CLLocationManager()
    var sceneView: SceneLocationView!
    
    var currentLocationFound = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = SceneLocationView()
        sceneView.locationDelegate = self
        sceneView.run()
        
        view.addSubview(sceneView)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneView.frame = view.bounds
    }
    
    // MARK: - SceneLocationViewDelegate
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        let coordinate = CLLocationCoordinate2D(latitude: 60.18505832049373, longitude: 24.831723738743346)
        let location = CLLocation(coordinate: coordinate, altitude: 30)
        let image = UIImage(named: "Pin")!
        
        let locationNode = LocationAnnotationNode(location: location, image: image)
        sceneView.addLocationNodeForCurrentPosition(locationNode: locationNode)
    }
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}
