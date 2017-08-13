//
//  MapViewController.swift
//  Soccer Squad
//
//  Created by Jay on 5/22/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol mapDelegate {
    func latitudeData(latitude: String)
    func longtitudeData(longtitude: String)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var LocationLabel: UILabel!
    
    var delegate:mapDelegate?
    var stringLatitude = ""
    var stringLongtitude = ""
    @IBAction func refreshItem(sender: AnyObject) {
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func SaveButton(sender: AnyObject) {
        
        
    }
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print("Got Location \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)")
        
        myPosition = newLocation.coordinate
        
        locationManager.stopUpdatingLocation()
        
        LocationLabel.text = "\(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)"
        
        let span = MKCoordinateSpanMake(0.75, 0.075)
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
        self.delegate?.latitudeData(self.stringLatitude)
        self.delegate?.longtitudeData(self.stringLongtitude)
        
        
        
        print("Pin Location : \(self.stringLatitude) , \(self.stringLongtitude)")
        
    }

}
