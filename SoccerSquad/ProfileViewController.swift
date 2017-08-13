//
//  ProfileViewController.swift
//  Soccer Squad
//
//  Created by Jay on 5/16/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ImageProfile: UIImageView!

    @IBOutlet weak var TelLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var EmailAddrLabel: UILabel!
    
    @IBOutlet weak var SexLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var CountTour: UILabel!
    @IBOutlet weak var CountField: UILabel!
    @IBOutlet weak var StatusTextView: UITextView!

    var uid = userId
    let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectOwner.php"
    let urlSelectField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedField.php"
    var refreshControl = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    var ownerID = ""
    
    var ownerName = ""
    var ownerImage = ""
    var ownerEmail = ""
    var ownerField = ""
    var ownerStatus = ""
    var ownerSex = ""
    var ownerTel = ""
    var ownerMode = ""
    
    
    
    
    var id = ""
    var fid = ""
    var fname = ""
    var ftype = ""
    var fcount = ""
    var fopen = ""
    var fcloe = ""
    var fprice = ""
    var fimage = ""
    var city = ""
    var country = ""
    
    
    
    
    
    var name = [String]()
    var userid = [String]()
    var fieldid = [String]()
    var typefield = [String]()
    var imagefield = [String]()
    var openfield = [String]()
    var closefield = [String]()
    var cityfield = [String]()
    var countryfield = [String]()
    var pricefield = [String]()
    var Owner = [String]()
    var indexPath = 0
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "detailField" {
            print("Detail Field")
            
            let des = segue.destinationViewController as! DetailFieldProfileView
            des.fieldID = self.fieldid[self.indexPath]
            des.uid = self.userid[self.indexPath]
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up the refresh control
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle

//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableview?.addSubview(refreshControl)
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            getOwnerField()
            getdataField()
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
            
        }
        
        
    }
    
    func refresh(sender:AnyObject) {
        self.getOwnerField()
        self.getdataField()
    }
    
    func getOwnerField() {
        
        var parameter:[String:String] = ["uid": uid]
        Activity().showLoading()
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
                    
                    
                    self.userid.append(self.ownerID)
                }
                
                
                self.navigationItem.title = self.ownerName
                self.EmailAddrLabel.text = self.ownerEmail
                self.StatusLabel.text = self.ownerMode
                self.SexLabel.text = self.ownerSex
                self.TelLabel.text = self.ownerTel
                self.StatusTextView.text = self.ownerStatus
                
                var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + self.ownerImage
                
                if urlImage.isEmpty {
                    self.ImageProfile.image = UIImage(named: "user")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.ImageProfile.image = UIImage(named: "user")
                            
                        }else {
                            
                            self.ImageProfile.image = image
                            self.ImageProfile.contentMode = .ScaleAspectFill
                            self.ImageProfile.layer.borderWidth = 1.0
                            self.ImageProfile.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                            self.ImageProfile.layer.masksToBounds = false
                            self.ImageProfile.layer.cornerRadius = self.ImageProfile.frame.size.height/2
                            self.ImageProfile.clipsToBounds = true
                            
                        }
                    }
                    
                }
                
        }
        
        // update "last updated" title for refresh control
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.refreshing
        {
            self.refreshControl.endRefreshing()
        }
        self.tableview.reloadData()
        Activity().hideLoading()
        
    }
    
    func getdataField() {
        var parameter:[String:String] = ["uid": uid, "segmemt":"1"]
        
        Activity().showLoading()
        Alamofire.request(.GET,urlSelectField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.fname = (value["fname"] as? String)!
                    self.ftype = (value["ftype"] as? String)!
                    self.fimage = (value["fimage"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    
                    self.name.append(self.fname)
                    self.typefield.append(self.ftype)
                    self.imagefield.append(self.fimage)
                    self.fieldid.append(self.fid)
                    
                    
                }
                // update "last updated" title for refresh control
                let now = NSDate()
                let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
                self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
                if self.refreshControl.refreshing
                {
                    self.refreshControl.endRefreshing()
                }
                self.tableview.reloadData()
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
    }

    
    //Table view Control
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count // your number of cell here
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableview.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! OutletFieldInProfile
        
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            if self.name[indexPath.row].isEmpty {
                myCell.NameField.text = "My Field is Empty."
                myCell.TypeField.text = "Type is Empty."
            } else {
            myCell.NameField.text = self.name[indexPath.row]
            myCell.TypeField.text = "Type: " + self.typefield[indexPath.row]
            
            print(name[indexPath.row])
            var urlImageField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.imagefield[indexPath.row]
            
            if urlImageField.isEmpty {
                myCell.ImageViewField.image = UIImage(named: "team")
            }else {
                
                downloadImage(urlImageField) { (image) in //เรียก เมอธอทดึงรูป
                    
                    if image == nil {
                        myCell.ImageViewField.image = UIImage(named: "team")
                        
                    }else {
                        
                        myCell.ImageViewField.image = image
                        myCell.ImageViewField.contentMode = .ScaleAspectFill
                        myCell.ImageViewField.layer.borderWidth = 1.0
                        myCell.ImageViewField.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                        myCell.ImageViewField.layer.masksToBounds = false
                        myCell.ImageViewField.layer.cornerRadius = myCell.ImageViewField.frame.size.height/2
                        myCell.ImageViewField.clipsToBounds = true
                        
                    }
                }
                
            }
            }
            
        }
        else {
            
            print("Internet connection FAILED")
            tableview.reloadData()
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
        // update "last updated" title for refresh control
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.refreshing
        {
            self.refreshControl.endRefreshing()
        }
        
        return myCell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        self.indexPath = indexPath.row
         performSegueWithIdentifier("detailField", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
}
