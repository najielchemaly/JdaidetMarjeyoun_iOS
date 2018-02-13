//
//  MapViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/22/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMapView() {
        //Location Manager code to fetch current location
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.mapType = .normal
        self.mapView.isMyLocationEnabled = true
        
        if let place = DatabaseObjects.selectedPlace {
            self.toolBarView.labelTitle.text = place.title
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            
            if let location = place.location {
                if !location.isEmpty {
                    let coordinates = location.characters.split{$0 == ","}.map(String.init)
                    let latitude = Double(coordinates.first!)
                    let longitude = Double(coordinates.first!)
                    if latitude != nil && longitude != nil {
                        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    }
                }
            }
            
            marker.title = place.title
            marker.map = self.mapView
        }
        
        self.view.sendSubview(toBack: self.mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 8.0)
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
