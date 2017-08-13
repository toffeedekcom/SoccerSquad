//
//  DetailFieldTableViewController.swift
//  Project2
//
//  Created by toffee on 6/19/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

var global_fieldID = ""

class DetailFieldTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var open_close: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city_country: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var ownerField: UILabel!
    @IBOutlet weak var imageOwner: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func settingButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("settingField", sender: nil)
    }
    
    let urlSelectField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectedFieldDetail.php"
    let urlSelectedOwner = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectOwner.php"
    let urlRemoveField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/removeField.php"
    
    
    var ids = userId
    var fieldID = ""
    var namefield = ""
    var typefield = ""
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
    var statusfield = ""
    
    
    var ownerid = ""
    
    var indexPath = 0
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    @IBAction func unwindToFieldDetail(segue:UIStoryboardSegue) {
        print("back Field Detail")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    
                    self.getOwnerField()
                    self.getFieldDetail()
                    if self.ids != self.ownerid {
                        self.navigationItem.rightBarButtonItem!.title = ""
                        self.navigationItem.rightBarButtonItem!.enabled = false
                    }
                }else if(net?.isReachableOnWWAN)! {
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    
                    self.getOwnerField()
                    self.getFieldDetail()
                    if self.ids != self.ownerid {
                        self.navigationItem.rightBarButtonItem!.title = ""
                        self.navigationItem.rightBarButtonItem!.enabled = false
                    }
                }else {
                    print("unknow")
                }
            }
            else {
                self.MyAlerts("No internet connnection")
                print("no connection")
            }
            
        }

        self.refreshControl?.addTarget(self, action: #selector(DetailFieldTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    
                    self.getOwnerField()
                    self.getFieldDetail()
                    if self.ids != self.ownerid {
                        self.navigationItem.rightBarButtonItem!.title = ""
                        self.navigationItem.rightBarButtonItem!.enabled = false
                    }
                }else if(net?.isReachableOnWWAN)! {
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    
                    self.getOwnerField()
                    self.getFieldDetail()
                    if self.ids != self.ownerid {
                        self.navigationItem.rightBarButtonItem!.title = ""
                        self.navigationItem.rightBarButtonItem!.enabled = false
                    }
                }else {
                    print("unknow")
                }
            }
            else {
                self.MyAlerts("No internet connnection")
                print("no connection")
            }
            
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "settingField" {
            let destination = segue.destinationViewController as! settingField
            destination.FieldID = self.fieldID
            destination.namefield = self.namefield
            destination.streetfield = self.streetfield
            destination.cityfield = self.cityfield
            destination.country = self.country
            destination.zipfield = self.zipfield
            destination.telfield = self.telfield
            destination.pricefield = self.pricefield
            destination.openfield = self.openfield
            destination.closefield = self.closefield
            destination.latitude = self.latitude
            destination.longtitude = self.longtitude
            destination.imagefield = self.imagefield
            destination.status = self.statusfield
            destination.uid = self.ownerid
        }else if segue.identifier == "listsubfield" {
            let destinationSub = segue.destinationViewController as! listSubfield
            destinationSub.fid = self.fieldID
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        getOwnerField()
        getFieldDetail()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getOwnerField() {
        
                self.ownerField.text = "Owner: "+self.ownefield

                var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.ownerImage
                
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

    
    func getFieldDetail() {
                self.title = self.namefield
                self.price.text = self.pricefield+" /hour"
                self.open_close.text = self.openfield+" - "+self.closefield
                self.street.text = self.streetfield
                self.city_country.text = self.cityfield+",  "+self.country
                self.zip.text = self.zipfield
                self.tel.text = self.telfield
        
        if self.statusfield == "ON" {
            self.statusLabel.text = "OPEN"
            statusLabel.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
            statusLabel.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
            statusLabel.layer.borderWidth = 1.0
            statusLabel.layer.cornerRadius = 10
            
        }else {
            self.statusLabel.text = "CLOSE"
            statusLabel.layer.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
            statusLabel.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
            statusLabel.layer.borderWidth = 1.0
            statusLabel.layer.cornerRadius = 10
            MyAlerts("The field is closed.")
        }
        
                let latitude = Double(self.latitude)
                let longtitude = Double(self.longtitude)
                
                if latitude > 0 || longtitude > 0 {
                    
                    let span = MKCoordinateSpanMake(0.01, 0.01)
                    let locCoord = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
                    let region = MKCoordinateRegion(center: locCoord, span: span)
                    let annotation = MKPointAnnotation()
                    
                    
                    annotation.coordinate = locCoord
                    annotation.title = self.namefield
                    annotation.subtitle = self.cityfield+", "+self.country
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(region, animated: true)
                }
                
                var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.imagefield
                
                
                if urlImage.isEmpty {
                    self.imageView.image = UIImage(named: "picture")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.imageView.image = UIImage(named: "picture")
                            
                        }else {
                            
                            self.imageView.image = image
                            self.imageView.contentMode = .ScaleAspectFill
                            
                        }
                    }
                    
                }

    }
    
    func getRemoveField() {
        
        var parameter:[String:String] = ["FieldID": fieldID]
        
        Alamofire.request(.GET,urlRemoveField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }
                
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
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
             
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
}
