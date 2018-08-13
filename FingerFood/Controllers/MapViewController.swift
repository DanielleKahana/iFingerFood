//
//  MapViewController.swift
//  FingerFood
//
//  Created by Mac on 06/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var latitude : Double = 0
    var longitude : Double = 0
    let regionRadius: CLLocationDistance = 1000
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: location)
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude  , longitude: longitude)
        mapView.addAnnotation(annotation)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func typeBtnPressed(_ sender: Any) {
    
    if mapView.mapType == MKMapType.standard {
        mapView.mapType = MKMapType.satellite
    } else {
        mapView.mapType = MKMapType.standard
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coords = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coords, animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
