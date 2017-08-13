//
//  DataField.swift
//  Project2
//
//  Created by toffee on 7/2/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit

class DataField: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var imageOwner: UIImageView!
    @IBOutlet weak var nameOwner: UILabel!
    @IBOutlet weak var emailOwner: UILabel!
    @IBOutlet weak var phoneOwner: UILabel!
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var zib: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var FieldID = ""
    var price = ""
    var uid = ""
    var fstatus = ""
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    var getLatitude = ""
    var getLongtitude = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.doDataField()
    }
    
    func doDataField(){
        self.btnBook.layer.cornerRadius = 12
        self.btnComment.layer.cornerRadius = 12
        let urlField = "https://nickgormanacademy.com/soccerSquat/booking/DataField.php"
        let parame:[String:String] = ["fid":FieldID]
        Alamofire.request(.GET,urlField,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.nameField.text  = (value["fname"] as? String)!
                        self.fstatus  = (value["fstatus"] as? String)!
                        self.nameOwner.text  = (value["uname"] as? String)!
                        self.emailOwner.text = (value["uemail"] as? String)!
                        self.phoneOwner.text = (value["uphone"] as? String)!
                        self.uid = (value["uid"] as? String)!
                        self.country.text = (value["fcountry"] as? String)!
                        self.city.text = (value["fcity"] as? String)!
                        self.zib.text = (value["fzip"] as? String)!
                        self.street.text = (value["fstreet"] as? String)!
                        self.phone.text = (value["fphone"] as? String)!
                        
                        self.getLatitude = (value["latitude"] as? String)!
                        self.getLongtitude = (value["lontitude"] as? String)!
                        
                        let latitude = Double(self.getLatitude)
                        let longtitude = Double(self.getLongtitude)
                        
                        if latitude > 0 || longtitude > 0 {
                            
                            let span = MKCoordinateSpanMake(0.01, 0.01)
                            let locCoord = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
                            let region = MKCoordinateRegion(center: locCoord, span: span)
                            let annotation = MKPointAnnotation()
                            
                            
                            annotation.coordinate = locCoord
                            annotation.title = self.nameField.text
                            annotation.subtitle = self.city.text!+", "+self.country.text!
                            self.mapView.addAnnotation(annotation)
                            self.mapView.setRegion(region, animated: true)
                        }

                        
                        var urlImageField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["fimage"] as? String)!
                        
                        
                        self.getNetworkImage(urlImageField) { (image) in //เรียก เมอธอทดึงรูป
                            self.imageField.image = image
                            self.imageField.contentMode = .ScaleAspectFill
                            self.imageField.layer.borderWidth = 1.0
                            self.imageField.layer.masksToBounds = false
                            self.imageField.layer.cornerRadius = self.imageField.frame.size.height/2
                            self.imageField.clipsToBounds = true
                        }
                        
                        
                        
                        var urlImageOwner = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["uimage"] as? String)!
                        
                        
                        self.getNetworkImage(urlImageOwner) { (image) in //เรียก เมอธอทดึงรูป
                            self.imageOwner.image = image
                            self.imageOwner.contentMode = .ScaleAspectFill
                            self.imageOwner.layer.borderWidth = 1.0
                            self.imageOwner.layer.masksToBounds = false
                            self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.height/2
                            self.imageOwner.clipsToBounds = true
                        }


                        
                    }
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
    
    
    }
    
    @IBAction func bookField(sender: AnyObject) {
        
        if (self.fstatus == "OFF") {
            var alert = UIAlertView(title: "alert", message: "The field is closed", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        }else{
             performSegueWithIdentifier("minifield", sender: self)
        }
       
        
    }
    
    @IBAction func comment(sender: AnyObject) {
        performSegueWithIdentifier("comment", sender: self)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "minifield") {
            let DestViewController = segue.destinationViewController as! MinifieldBooking
            // let DestViewController = navController.topViewController as! MinifieldBooking
            
            DestViewController.price = self.price
            DestViewController.memberFieldID = self.FieldID
            
        }
        else if(segue.identifier == "comment"){
             let DestViewController = segue.destinationViewController as! OwnerComment
            DestViewController.fid = self.FieldID
            DestViewController.userid = self.uid
            
        
        }
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
        self.tabBarController?.selectedIndex = 2
    
    }
    

    

}
