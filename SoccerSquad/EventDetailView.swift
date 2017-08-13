//
//  EventDetailView.swift
//  Project2
//
//  Created by CSmacmini on 6/23/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import FBSDKLoginKit
import FBSDKShareKit
import Social

class EventDetailView: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    var uid = userId
    var EventID = ""
    var FieldID = ""
    var chkID = ""
    var urlImage = ""
    
    
    let urlRemoveEvent = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/removeEvent.php"
    
    
    var Eventname = ""
    var Eventdetail = ""
    var Eventstart = ""
    var Eventstop = ""
    var Eventimage = ""
    
    var Fieldname = ""
    var Fieldstreet = ""
    var Fieldcity = ""
    var Fieldcountry = ""
    var Fieldtel = ""
    var Fieldimage = ""
    var Fieldlatitude = ""
    var Fieldlongtitude = ""
    var Field_count = ""
    
    
    //Selected Team
    var tourid = ""
    var teamid = ""
    
    var ListTeam = [String]()
    
    var uids = ""
    var userid = [String]()
    
    
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var placename: UILabel!
    @IBOutlet weak var placetype: UILabel!
    @IBOutlet weak var placestreet: UILabel!
    @IBOutlet weak var placecity_country: UILabel!
    @IBOutlet weak var placetel: UILabel!
    @IBOutlet weak var placeimage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var dateOpen: UILabel!
    @IBOutlet weak var dateClose: UILabel!
    @IBOutlet weak var timeClose: UILabel!
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var displayCount_team: UILabel!
    @IBOutlet weak var customIMG: UIImageView!
    @IBOutlet weak var customBTNshare: UIButton!
    
    @IBAction func ShareAction(sender: AnyObject) {
        
//        let content = FBSDKShareLinkContent()
//        let url = NSURL(string: urlImage)
//        content.contentTitle = "Posted with my Socceer Squad App."
//        content.contentDescription = "NEW Tournament!!!"
//        content.imageURL = url!
//        
//        print(url!)
        
        self.urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.Eventimage
        
        if urlImage.isEmpty {
            self.image.image = UIImage(named: "picture")
        }else {
            
            self.downloadImage(urlImage) { (imageS) in
                
                if imageS == nil {
                    self.image.image = UIImage(named: "picture")
                    
                }else {
                    
                    self.image.image = imageS
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                        var myFBController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                        myFBController.setInitialText("NEW Tournament")
                        myFBController.addImage(imageS)
                        self.presentViewController(myFBController, animated: true, completion: nil)
                    } else {
                        let alertView = UIAlertView()
                        alertView.message = "Please login to Facebook."
                        alertView.addButtonWithTitle("OK")
                        
                        alertView.show()
                    }
                }
            }
            
        }
        

        
    }
    
    @IBAction func ControlEvent(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Setting",message: "Choose what you want to edit.",preferredStyle: .Alert)
        
        let action1 = UIAlertAction(title: "Edit Tournament", style: .Default, handler: { (action) -> Void in
            
            self.performSegueWithIdentifier("editevent", sender: self)
        })
        
        let action2 = UIAlertAction(title: "Remove Tournament", style: .Default, handler: { (action) -> Void in
            
            let alertController = UIAlertController(title: "Alert!", message: "Ara you sure remove Tournament ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                
                self.getRemoveEvent()
                self.performSegueWithIdentifier("unwindToTournament", sender: self)
            })
            
            let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
                
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "teamtour" {
            let vc = segue.destinationViewController as! TeamListView
            vc.tour_id = tourid
            vc.team_id = ListTeam
        }else if segue.identifier == "editevent" {
            let vc = segue.destinationViewController as! EventEdit
            vc.VenueNAME = self.Fieldname
            vc.pass_ImageVenue = self.placeimage.image
        }else {
            print("Unknow segue")
        }
    }
    
    @IBAction func unwindToTournamentDetail(segue:UIStoryboardSegue) {
        print("back Tournament Detail")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        customButton.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        customButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        customButton.layer.borderWidth = 1.0
        customButton.layer.cornerRadius = 10
        customIMG.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        customIMG.layer.borderWidth = 1.0
        customIMG.layer.cornerRadius = 10
        
        customBTNshare.layer.borderColor = UIColor.clearColor().CGColor
        customBTNshare.layer.borderWidth = 1.0
        customBTNshare.layer.cornerRadius = 10
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    //do some stuff
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    self.navigationItem.title = self.Eventname
                    self.getEventDetail()
                    self.getPlaceDetail()
                    self.SelectedTeam()
                    self.detailTournament()
                }else if(net?.isReachableOnWWAN)! {
                    //do some stuff
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    self.navigationItem.title = self.Eventname
                    self.getEventDetail()
                    self.getPlaceDetail()
                    self.SelectedTeam()
                    self.detailTournament()
                }else {
                    print("unknow")
                }
            }
            else {
                self.MyAlerts("No internet connnection")
                print("no connection")
            }
            
        }
        
        self.refreshControl?.addTarget(self, action: #selector(EventDetailView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        getEventDetail()
        getPlaceDetail()
        SelectedTeam()
        detailTournament()
        tableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        getEventDetail()
        getPlaceDetail()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getEventDetail() {
        
        var strDateOpen = self.Eventstart
        var strDateClose = self.Eventstop
        
        var slitDateOpen = strDateOpen.characters.split{$0 == " "}.map(String.init)
        var slitDateClose = strDateClose.characters.split{$0 == " "}.map(String.init)
        
        self.detail.text = " "+self.Eventdetail
        
        self.timing.text = slitDateOpen[1]
        self.dateOpen.text = slitDateOpen[0]
        self.timeClose.text = slitDateClose[1]
        self.dateClose.text = slitDateClose[0]
        
        self.urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.Eventimage
        
        if urlImage.isEmpty {
            self.image.image = UIImage(named: "picture")
        }else {
            
            self.downloadImage(urlImage) { (image) in
                
                if image == nil {
                    self.image.image = UIImage(named: "picture")
                    
                }else {
                    
                    self.image.image = image
                    self.image.contentMode = .ScaleAspectFill
                    //                            self.image.layer.borderWidth = 1.0
                    //                            self.image.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    self.image.layer.masksToBounds = false
                    //                            self.image.layer.cornerRadius = self.image.frame.size.height/2
                    self.image.clipsToBounds = true
                    
                }
            }
            
        }
        
        
        Activity().hideLoading()
        
        
        
    }
    
    func getPlaceDetail() {
        
        
        self.placename.text = "Field name: "+self.Fieldname
        self.placestreet.text = "Address: "+self.Fieldstreet
        self.placecity_country.text = "City: "+self.Fieldcity
        self.Country.text = "Country: "+self.Fieldcountry
        self.placetel.text = "Tel: "+self.Fieldtel
        
        let latitude = Double(self.Fieldlatitude)
        let longtitude = Double(self.Fieldlongtitude)
        
        
        if latitude > 0 || longtitude > 0 {
            
            let span = MKCoordinateSpanMake(0.010, 0.010)
            let locCoord = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
            let region = MKCoordinateRegion(center: locCoord, span: span)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = locCoord
            annotation.title = self.Fieldname
            annotation.subtitle = self.Fieldcity+", "+self.Fieldcountry
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
        }else {
            print("Location Not Found")
        }
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.Fieldimage
        
        if urlImage.isEmpty {
            self.placeimage.image = UIImage(named: "logo")
        }else {
            
            self.downloadImage(urlImage) { (image) in
                
                if image == nil {
                    self.placeimage.image = UIImage(named: "logo")
                    
                }else {
                    
                    self.placeimage.image = image
                    self.placeimage.contentMode = .ScaleAspectFill
                    self.placeimage.layer.borderWidth = 2.0
                    self.placeimage.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    self.placeimage.layer.masksToBounds = false
                    self.placeimage.layer.cornerRadius = self.placeimage.frame.size.height/2
                    self.placeimage.clipsToBounds = true
                    Activity().hideLoading()
                }
            }
            
        }
        
        
    }
    
    
    func SelectedTeam() {
        self.ListTeam = []
        
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectTeamTour.php"
        var parameter:[String:String] = ["tourid": tourid]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }else {
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.tourid = (value["tourid"] as? String)!
                        self.teamid = (value["tid"] as? String)!
                        
                        self.ListTeam.append(self.teamid)
                    }
                    
                    self.displayCount_team.text = String(self.ListTeam.count)+"/"+self.Field_count
                    Activity().hideLoading()
                }
        }
        
    }
    
    func detailTournament() {
        Activity().hideLoading()
        
        let urlEvent = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectdetailEvent.php"
        var parameter:[String:String] = ["tourid": tourid]
        
        Alamofire.request(.GET,urlEvent ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.uids = (value["uid"] as? String)!
                    
                    self.userid.append(self.uid)
                }
                
                if self.uid != self.uids {
                    //                    self.navigationItem.rightBarButtonItem!.title = ""
                    self.navigationItem.rightBarButtonItem!.enabled = false
                }
                
        }
        
    }
    
    func getRemoveEvent() {
        Activity().showLoading()
        var parameter:[String:String] = ["EventID": EventID]
        
        Alamofire.request(.GET,urlRemoveEvent ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                Activity().hideLoading()
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
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
}
