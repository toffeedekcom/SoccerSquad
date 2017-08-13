//
//  profileTableView.swift
//  Project2
//
//  Created by CSmacmini on 6/30/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class profileTableView: UITableViewController{
    @IBOutlet weak var ImageProfile: UIImageView!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailAddrLabel: UILabel!
    
    @IBOutlet weak var SexLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var CountTour: UILabel!
    @IBOutlet weak var CountField: UILabel!
    @IBOutlet weak var StatusTextView: UITextView!
    
    @IBOutlet weak var customEditprofileButton: UIButton!
    @IBAction func Editprofile(sender: AnyObject) {   
        performSegueWithIdentifier("editprofile", sender: self)
    }
    @IBAction func optionButton(sender: AnyObject) {
        performSegueWithIdentifier("option", sender: self)
    }
    @IBAction func searchButton(sender: AnyObject) {
    }
    
    
    var uid = userId
    let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectOwner.php"
    let urlSelectField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedField.php"
    let urlSelectEvent = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedEvent.php"
    var ownerID = ""
    
    var ownerName = ""
    var ownerImage = ""
    var ownerEmail = ""
    var ownerField = ""
    var ownerStatus = ""
    var ownerSex = ""
    var ownerTel = ""
    var ownerMode = ""
    var ownerPass = ""
    

    var fname = ""
  
    var name = [String]()
    var userid = [String]()
    var fieldid = [String]()
    var typefield = [String]()
    var imageOwner = [String]()
    var openfield = [String]()
    var closefield = [String]()
    var cityfield = [String]()
    var countryfield = [String]()
    var pricefield = [String]()
    var Owner = [String]()
    var indexPath = 0
    
    var tourname = ""
    var nametour:[String] = []
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "option" {
            let desVC = segue.destinationViewController as! costomOptionProfile
            desVC.uid = ownerID
            desVC.email = ownerEmail
            desVC.pass = ownerPass
        }
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        print("back profile")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(profileTableView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.tabBarController?.tabBar.hidden = false
        tableview.reloadData()
        tableview.allowsSelection = false
        customEditprofileButton.layer.cornerRadius = 10
        customEditprofileButton.layer.borderWidth = 1.0
        customEditprofileButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            getOwnerField()
            getTournament()
            getdataField()
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
            
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        getOwnerField()
    }
    

    func getOwnerField() {
        
        var parameter:[String:String] = ["uid": uid]
        Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.ownerName  = (value["uname"] as? String)!
                    self.ownerImage  = (value["uimage"] as? String)!
                    self.ownerEmail = (value["uemail"] as? String)!
                    self.ownerID = (value["uid"] as? String)!
                    self.ownerStatus = (value["ustatus"] as? String)!
                    self.ownerMode = (value["udetail"] as? String)!
                    self.ownerSex = (value["usex"] as? String)!
                    self.ownerTel = (value["uphone"] as? String)!
                    self.ownerPass = (value["upassword"] as? String)!
                    
                    
//                    self.userid.append(self.ownerID)
                }
                
                
                self.navigationItem.title = self.ownerName
                self.EmailAddrLabel.text = self.ownerEmail
                self.SexLabel.text = self.ownerSex
                self.NameLabel.text = self.ownerName
                self.StatusTextView.text = self.ownerStatus
                
                let urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.ownerImage
                
                if urlImage.isEmpty {
                    self.ImageProfile.image = UIImage(named: "picture")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.ImageProfile.image = UIImage(named: "picture")
                            
                        }else {
                            
                            self.ImageProfile.image = image
                            self.ImageProfile.contentMode = .ScaleAspectFill
                            self.ImageProfile.layer.borderWidth = 1.5
                            self.ImageProfile.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                            self.ImageProfile.layer.masksToBounds = false
                            self.ImageProfile.layer.cornerRadius = self.ImageProfile.frame.size.height/2
                            self.ImageProfile.clipsToBounds = true
                            
                        }
                    }
                    
                }
        }
        
    }
    
    func getdataField() {
        var parameter:[String:String] = ["uid": uid, "segmemt":"1"]
        Alamofire.request(.GET,urlSelectField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {

                    self.fname = (value["fname"] as? String)!

                    self.name.append(self.fname)
   
                }
                self.tableView.reloadData()
                self.CountField.text = String(self.name.count)
                
        }
        
        
    }
    
    func getTournament() {
        var parameter:[String:String] = ["uid": uid, "segmemt":"1"]
        Alamofire.request(.GET,urlSelectEvent ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {

                    self.tourname = (value["tourname"] as? String)!

                    self.nametour.append(self.tourname)
    
                }
                self.tableView.reloadData()
                self.CountTour.text = String(self.nametour.count)
                
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {

        getOwnerField()
//        getdataField()
//        getTournament()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    

}
