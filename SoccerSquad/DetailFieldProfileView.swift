//
//  DetailFieldProfileView.swift
//  Project2
//
//  Created by Jay on 6/27/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class DetailFieldProfileView: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var open_close: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city_country: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var ownerField: UILabel!
    @IBOutlet weak var imageOwner: UIImageView!
    @IBOutlet weak var imageStatus: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var SexLabel: UILabel!
    
    @IBOutlet weak var emailOwnerLabel: UILabel!
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
        print("Back")
        
    }
    
    @IBAction func ControlField(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Select",message: "Select the function you want.",preferredStyle: .Alert)
        
        let action1 = UIAlertAction(title: "Edit Field", style: .Default, handler: { (action) -> Void in
            print("ACTION 1 selected!")
            
            self.performSegueWithIdentifier("edit", sender: self)
        })
        
        let action2 = UIAlertAction(title: "Remove Field", style: .Default, handler: { (action) -> Void in
            print("ACTION 2 selected!")
            
            let alertController = UIAlertController(title: "Alert!", message: "Ara you sure remove field ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                print("Perform Remove action")
                self.getRemoveField()
            })
            
            let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
                print("Perform Cancel action")
            })
            
            alertController.addAction(okAction)
            alertController.addAction(deleteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
            alertController.view.layer.cornerRadius = 25
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0) // change text color of the buttons
        
        alert.view.layer.cornerRadius = 25   // change corner radius
        
        
        
    }
    let urlSelectField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectedFieldDetail.php"
    let urlSelectedOwner = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectOwner.php"
    let urlRemoveField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/removeField.php"
    
    
    var ids = userId
    var fieldID = ""
    var namefield = ""
    var typefield = ""
    var countfield = ""
    var openfield = ""
    var closefield = ""
    var streetfield = ""
    var cityfield = ""
    var country = ""
    var zipfield = ""
    var telfield = ""
    var imagefield = ""
    var latitude = ""
    var longtitude = ""
    var pricefield = ""
    var ownefield = ""
    var ownerImage = ""
    var ownerEmail = ""
    var ownerDetail = ""
    var ownerSex = ""
    
    var chkID = ""
    
    
    var uid = ""
    
    var indexPath = 0
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            getOwnerField()
            getFieldDetail()
            
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "edit" {
            let destination = segue.destinationViewController as! EditFieldProfileView
            destination.fieldID = self.fieldID
            destination.namefield = self.namefield
            destination.streetfield = self.streetfield
            destination.cityfield = self.cityfield
            destination.countfield = self.countfield
            destination.country = self.country
            destination.zipfield = self.zipfield
            destination.telfield = self.telfield
            destination.pricefield = self.pricefield
            destination.openfield = self.openfield
            destination.closefield = self.closefield
            destination.latitude = self.latitude
            destination.longtitude = self.longtitude
            destination.imagefield = self.imagefield
            destination.typefield = self.typefield
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOwnerField() {
        
        var parameter:[String:String] = ["uid": uid]
        
        Alamofire.request(.GET,urlSelectedOwner ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.ownefield  = (value["uname"] as? String)!
                    self.ownerImage  = (value["uimage"] as? String)!
                    self.ownerEmail = (value["uemail"] as? String)!
                    self.ownerDetail = (value["udetail"] as? String)!
                    self.ownerSex = (value["usex"] as? String)!
                    
                }
                self.ownerField.text = "Owner: "+self.ownefield
                self.emailOwnerLabel.text = "Email: "+self.ownerEmail
                self.SexLabel.text = "Sex: "+self.ownerSex
                
                print(self.ownerField)
                
                
                var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + self.ownerImage
                
                if urlImage.isEmpty {
                    self.imageOwner.image = UIImage(named: "user")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.imageOwner.image = UIImage(named: "user")
                            
                        }else {
                            
                            self.imageOwner.image = image
                            self.imageOwner.contentMode = .ScaleAspectFill
                            self.imageOwner.layer.borderWidth = 1.0
                            self.imageOwner.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                            self.imageOwner.layer.masksToBounds = false
                            self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.height/2
                            self.imageOwner.clipsToBounds = true
                            
                        }
                    }
                    
                }
                
        }
        
    }
    
    
    func getFieldDetail() {
        
        var parameter:[String:String] = ["uid": ids, "fid": fieldID]
        
        Alamofire.request(.GET,urlSelectField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.namefield  = (value["fname"] as? String)!
                    self.typefield  = (value["ftype"] as? String)!
                    self.imagefield = (value["fimage"] as? String)!
                    self.openfield = (value["ftime_in"] as? String)!
                    self.closefield = (value["ftime_out"] as? String)!
                    self.cityfield = (value["fcity"] as? String)!
                    self.country = (value["fcountry"] as? String)!
                    self.zipfield = (value["fzip"] as? String)!
                    self.telfield = (value["fphone"] as? String)!
                    self.streetfield = (value["fstreet"] as? String)!
                    self.latitude = (value["latitude"] as? String)!
                    self.longtitude = (value["lontitude"] as? String)!
                    self.pricefield = (value["fprice"] as? String)!
                    self.chkID = (value["uid"] as? String)!
                    
                    //                    self.uid = (value["uid"] as? String)!
                    self.fieldID = (value["fid"] as? String)!
                    
                }
                self.title = self.namefield
                self.type.text = "Type: "+self.typefield
                self.open_close.text = "Open: "+self.openfield+",  "+"Close: "+self.closefield
                self.street.text = "Address: "+self.streetfield
                self.city_country.text = "City: "+self.cityfield+",  "+"Country: "+self.country
                self.zip.text = "Zip: "+self.zipfield
                self.tel.text = "Tel: "+self.telfield
                
                if self.ids != self.chkID {
                    self.navigationItem.rightBarButtonItem!.title = ""
                    self.navigationItem.rightBarButtonItem!.enabled = false
                }
                
                let latitude = Double(self.latitude)
                let longtitude = Double(self.longtitude)
                
                if latitude > 0 || longtitude > 0 {
                    let locCoord = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = locCoord
                    annotation.title = self.namefield
                    annotation.subtitle = self.cityfield+", "+self.country
                    self.mapView.addAnnotation(annotation)
                }
                
                var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.imagefield
                
                self.imageStatus.image = UIImage(named: "statusFull")
                
                if urlImage.isEmpty {
                    self.imageView.image = UIImage(named: "picture")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.imageView.image = UIImage(named: "picture")
                            
                        }else {
                            
                            self.imageView.image = image
                            self.imageView.contentMode = .ScaleAspectFill
                            //                            self.imageView.layer.borderWidth = 1.0
                            //                            self.imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                            //                            self.imageView.layer.masksToBounds = false
                            //                            self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
                            //                            self.imageView.clipsToBounds = true
                            
                        }
                    }
                    
                }
                
        }
        
    }
    
    func getRemoveField() {
        
        var parameter:[String:String] = ["FieldID": fieldID]
        
        Alamofire.request(.GET,urlRemoveField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.fieldID = (value["fid"] as? String)!
                    
                }
                if self.fieldID.isEmpty {
                    self.MyAlerts("Remove Success!")
                }else {
                    self.MyAlerts("Remove Fail!")
                }
                
        }
        
        
    }
    
    
    
    //download image in database
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            //print(image)
            completion(image_Field)
        }
    }
    
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("Got Location \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)")
        
        myPosition = newLocation.coordinate
        
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpanMake(3.0, 3.0)
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    


}
