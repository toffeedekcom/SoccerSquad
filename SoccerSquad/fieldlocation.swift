//
//  fieldlocation.swift
//  Project2
//
//  Created by CSmacmini on 6/25/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol VCTwoDelegate {
    func updateLatitude(latitude: String)
    func updateLongtitude(lontitude: String)
}

class fieldlocation: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate{

    var delegate: VCTwoDelegate?
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    var stringLatitude = ""
    var stringLongtitude = ""
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let locCoord = CLLocationCoordinate2D(latitude: 25.123, longitude: 55.123)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locCoord
        annotation.title = "My Location"
        annotation.subtitle = "Location of Field"
        
        mapView.addAnnotation(annotation)

    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        myPosition = newLocation.coordinate
        
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpanMake(3.0, 3.0)
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func addPin(sender: UILongPressGestureRecognizer) {
        
        let  location = sender.locationInView(self.mapView)
        
        let locCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locCoord
        annotation.title = "My Field"
        annotation.subtitle = "Location of Field"
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        self.stringLatitude = String(locCoord.latitude)
        self.stringLongtitude = String(locCoord.longitude)
        self.delegate?.updateLatitude(self.stringLatitude)
        self.delegate?.updateLongtitude(self.stringLongtitude)
        
        
        
        print("Pin Location : \(self.stringLatitude) , \(self.stringLongtitude)")
        
    }


}
