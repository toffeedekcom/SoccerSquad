//
//  locationViewController.swift
//  Project2
//
//  Created by Jay on 6/20/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import MapKit

class locationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refreshItem(sender: AnyObject) {
        
        locationManager.startUpdatingLocation()
        getlocationField()
    }
    
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    var dataFieldlatitude = ""
    var dataFieldlongtitude = ""
    var dataFieldname = ""
    var dataFieldDetail = ""
    
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            getlocationField()
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        

    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("Got Location \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)")
        
        myPosition = newLocation.coordinate
        
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpanMake(3.0, 3.0)
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func getlocationField() {
        
        let latitude = Double(dataFieldlatitude)
        let longtitude = Double(dataFieldlongtitude)

        
        if latitude > 0 || longtitude > 0 {
            let locCoord = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = locCoord
            annotation.title = dataFieldname
//            annotation.subtitle = dataField.cityfield+", "+dataField.country
            
            mapView.addAnnotation(annotation)
        }else {
            MyAlerts("Location not found!")
        }

        
    }
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    
}
