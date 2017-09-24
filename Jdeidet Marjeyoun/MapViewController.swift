//
//  MapViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/22/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
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
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 33.364202, longitude: 35.587387, zoom: 6.0)
        self.mapView.camera = camera
        self.mapView.mapType = .satellite
        
        if let place = DatabaseObjects.selectedPlace {
            self.toolBarView.labelTitle.text = place.title
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            
            if let location = place.location {
                let coordinates = location.characters.split{$0 == ","}.map(String.init)
                let latitude = Double(coordinates.first!)
                let longitude = Double(coordinates.first!)
                marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            }
            
            marker.position = CLLocationCoordinate2D(latitude: 33.364202, longitude: 35.587387)
            marker.title = place.title
            marker.map = mapView
        }
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
