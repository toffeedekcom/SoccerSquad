//
//  TournamentEvent.swift
//  Project2
//
//  Created by toffee on 6/28/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit


class TournamentEvent: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var imageTournament: UIImageView!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var dateTournament: UILabel!
    
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var numberAmount: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var tournamentId = ""
    
    var tourId = ""
    var imageTour = ""
    var detailTour = ""
    var date = ""
    var imgField =  ""
    var countryField = ""
    var cityField = ""
    var phoneField = ""
    var emailField = ""
    var nField = ""
    var tid = "" // id ทีมที่จะเอาลง DB
    var addTourId = [String]()
     var check = ""
    var joinTourId = ""
    var amount = ""
    var responseAmount = ""
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    var getLatitude = ""
    var getLongtitude = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("amount = \(amount)")
        self.checkAmount()

       self.doTournaMent()
        
    }
    
    func doTournaMent(){

        var urlSegment = "https://nickgormanacademy.com/soccerSquat/event/TournamentEvent.php"
        var parameter:[String:String] = [ "type":"datatournament" , "tournamentId":self.tournamentId]
        Alamofire.request(.GET,urlSegment,parameters: parameter , encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                
                for value in JSON {
                    self.dateTournament.text  = (value["tour_date"] as? String)!
                    self.detail.text  = (value["tourdetail"] as? String)!
                    
                    self.country.text  = (value["fcountry"] as? String)!
                    self.city.text = (value["fcity"] as? String)!
                    self.phone.text = (value["fphone"] as? String)!
                    self.nameField.text = (value["fname"] as? String)!
                    
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

                    
                    self.numberAmount.text = self.amount
                    var urlImageTour = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["tourimage"] as? String)!
                    
                    self.getNetworkImage(urlImageTour) { (image) in //เรียก เมอธอทดึงรูป
                        self.imageTournament.image = image
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

                    
                }
               
                
                self.tableView.reloadData()
               
        }

        
        ////// action button join
        var urlCheckTour = "https://nickgormanacademy.com/soccerSquat/event/CheckMemberTournament.php"
         var urlDataTeamJoin = "https://nickgormanacademy.com/soccerSquat/event/eventtournament/DataTeamJoin.php"
        var parameCheckTour:[String:String] = [ "uid":userId ,"tournamentId":self.tournamentId]
        //var parameTeam:[String:String] = [ "tid":self.tid ]
       
        
        Alamofire.request(.GET,urlCheckTour,parameters: parameCheckTour , encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                
                for value in JSON {
                    self.check  = (value["chack"] as? String)!
                    
                    if(self.check == "1"){//เป็นสมาชิกอยู่แล้ว
                        
                        Alamofire.request(.GET,urlDataTeamJoin,parameters: parameCheckTour , encoding: .URL).validate()
                            .responseJSON{(response) in
                                
                                switch response.result {
                                case .Success:
                                    
                                    var JSON = [AnyObject]()
                                    JSON = response.result.value as! [AnyObject]!
                                    
                                    for value in JSON {
                                        self.team.text  = (value["tname"] as? String)!
                                        self.tid = (value["tid"] as? String)!
                                        self.joinTourId = (value["jointourid"] as? String)!
                                    }
                                    self.tableView.reloadData()
                                    
                                case .Failure(let error):
                                    print(error)
                                }
                               
                        }
                        
                        self.buttonSave.layer.cornerRadius = 12
                        self.buttonSave.setTitle("Out", forState: .Normal)
                        self.buttonSave.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
                        self.buttonSave.tag = 1
                        self.buttonSave.addTarget(self, action: "buttonJoin:",
                        forControlEvents: UIControlEvents.TouchUpInside)
                        
                    }
                    else{/// ยังไม่เป็นสมาชิก
                        
                        if(self.responseAmount == "full"){ //เช็คว่าทีมเต็มยัง
                            
                            
                            self.buttonSave.layer.cornerRadius = 12
                            self.buttonSave.setTitle("Full", forState: .Normal)
                            self.buttonSave.backgroundColor = UIColor(red:0.51, green:0.91, blue:0.59, alpha:1.0)
                            //self.buttonSave.tag = 0
                            //self.buttonSave.addTarget(self, action: "buttonJoin:",
                                //forControlEvents: UIControlEvents.TouchUpInside)
                        
                        
                        }
                        else{ //ถ้าทีมยังไม่เต็มก็จะสามารถ join ได้
                            
                            self.buttonSave.layer.cornerRadius = 12
                            self.buttonSave.setTitle("Join", forState: .Normal)
                            self.buttonSave.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
                            self.buttonSave.tag = 0
                            self.buttonSave.addTarget(self, action: "buttonJoin:",
                                forControlEvents: UIControlEvents.TouchUpInside)
                        }
                        
                        
                    }
                    
                    
                }
                
                
                self.tableView.reloadData()
                
        }

    }
    
    func checkAmount() {
        var urlSegment = "https://nickgormanacademy.com/soccerSquat/event/eventtournament/CheckAmount.php"
        var parameter:[String:String] = [ "amount":self.amount , "tournamentId":self.tournamentId]
        Alamofire.request(.GET,urlSegment,parameters: parameter , encoding: .URL).validate()
            .responseJSON{(response) in
                switch response.result{
                    case .Success:
                        var JSON = [AnyObject]()
                        JSON = response.result.value as! [AnyObject]!
                        
                        for value in JSON {
                            self.responseAmount  = (value["fully"] as? String)!
                            
                        }
                        print("status = \(self.responseAmount)")
                        self.tableView.reloadData()
                    
                    
                    case .Failure(let error):
                     print("error")
                
                }
        
        
        }

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 4 && indexPath.row == 0) {
            if(self.check == "1"){
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            else{
                if (self.responseAmount == "full") {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
                else{
                    performSegueWithIdentifier("selecteam", sender: self)
                }
                
            }
           
        }
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
    
    func buttonJoin(sender: UIButton!) {  //ButtonJoin
        
        var urljoin = "https://nickgormanacademy.com/soccerSquat/event/eventtournament/JoinTournamentEvent.php"
        var paramejoin:[String:String] = [ "tid":self.tid , "tournamentId":self.tournamentId]
        
        var urlOutTour = "https://nickgormanacademy.com/soccerSquat/event/eventtournament/OutTournamentEvent.php"
        var parameOutTour:[String:String] = [  "tournamentId":self.joinTourId]
        print("joinTourid = \(self.joinTourId)")
        
        if (sender.tag == 0) {
            
                if(self.tid == ""){
                    
                        var alert = UIAlertView(title: "Error", message: "Please Enter a Team. ", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                }
                else{
                        Alamofire.request(.GET,urljoin,parameters: paramejoin , encoding: .URL).validate()
                            .responseJSON{(response) in

                        
                        }
                }
            
                self.doTournaMent()
        }
        else{
            
                Alamofire.request(.GET,urlOutTour,parameters: parameOutTour , encoding: .URL).validate()
                .responseJSON{(response) in
                    
                }
                self.doTournaMent()
             print("Cancel")
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selecteam" {
             (segue.destinationViewController as! teamJoinTournament).delegate = self
        }
        if (segue.identifier == "listteam") {
            let DestViewController = segue.destinationViewController as! ListTeamTournament
            DestViewController.tourId = self.tournamentId
            
        }

    }

    @IBAction func listJoin(sender: AnyObject) {
        performSegueWithIdentifier("listteam", sender: self)
        
    }
    
}

extension TournamentEvent: getField {
    func getplaceID(tid: String) {
        self.tid = tid
    }
    
    func getplaceName(tname: String) {
        self.team.text = tname
    }
}

