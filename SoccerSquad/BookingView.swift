//
//  BookingView.swift
//  Project2
//
//  Created by Jay on 7/6/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class BookingView: UITableViewController {
    
    var uid = userId
    var fid = ""
    var mnfid = ""
    
    var mnfname = ""
    var mnfsize = ""
    var mnfimage = ""
    var mnfstatus = ""
    
    var fimage = ""
    var fname = ""
    var fdate = ""
    
    
    var get_mnfid = ""
    
    
    //arrays data
    var arrfield_id = [String]()
    var arrMNF_id = [String]()
    
    var arrMNF_name = [String]()
    var arrMNF_size = [String]()
    var arrMNF_image = [String]()
    var arrMNF_status = [String]()
    
    var arrfield_image = [String]()
    var arrfield_name = [String]()
    var arrfield_date = [String]()
    
    var indexPath = 0
    
    var passField_id = ""
    var passminiField_id = ""
    
    
    @IBAction func setting(sender: AnyObject) {
        //        self.performSegueWithIdentifier("settingBooking", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "accountlist" {
            let desVC = segue.destinationViewController as! banklistView
            desVC.fid = self.passField_id
            
        }else if segue.identifier == "bookingDetail" {
            let desVC = segue.destinationViewController as! BookingList
            desVC.mnf_id = self.passminiField_id
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        tableView.allowsSelection = false
        self.refreshControl?.addTarget(self, action: #selector(BookingView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        selectField()
        
        
    }
    
    func selectField() {
        self.arrfield_id = []
        self.arrMNF_id = []
        self.arrMNF_name = []
        self.arrMNF_size = []
        self.arrMNF_image = []
        self.arrMNF_status = []
        self.arrfield_image = []
        self.arrfield_name = []
        self.arrfield_date = []
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectJoinField.php"
        var parameter:[String:String] = ["uid": uid]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    self.MyAlerts("Not Data")
                    
                }else{
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.fid = (value["fid"] as? String)!
                        self.mnfid = (value["mnf_id"] as? String)!
                        
                        self.mnfname = (value["mnf_type"] as? String)!
                        self.mnfsize = (value["mnf_size"] as? String)!
                        self.mnfimage = (value["mnf_image"] as? String)!
                        
                        self.fimage = (value["fimage"] as? String)!
                        self.fname = (value["fname"] as? String)!
                        self.fdate = (value["fdate"] as? String)!
                        
                        self.arrfield_id.append(self.fid)
                        self.arrMNF_id.append(self.mnfid)
                        
                        self.arrMNF_name.append(self.mnfname)
                        self.arrMNF_size.append(self.mnfsize)
                        self.arrMNF_image.append(self.mnfimage)
                        
                        self.arrfield_image.append(self.fimage)
                        self.arrfield_name.append(self.fname)
                        self.arrfield_date.append(self.fdate)
                    }
                }
                //                print("fid :\(self.arrfield_id), mnf \(self.arrMNF_id)")
                
                self.tableView.reloadData()
        }
        
    }
    
    func More() {
        let alert = UIAlertController(title: "More",message: "Choose your lists.",preferredStyle: .Alert)
        
        let action1 = UIAlertAction(title: "Bank Account", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("accountlist", sender: self)
            
        })
        
        let action2 = UIAlertAction(title: "Booking List", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("bookingDetail", sender: self)
            
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
        
        //        self.performSegueWithIdentifier("bookingDetail", sender: self)
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        selectField()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        self.indexPath = indexPath.row
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 300
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        
        return arrMNF_id.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("bookingUI", forIndexPath: indexPath) as! bookingUI
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            myCell.namefield.text = arrfield_name[indexPath.row]
            myCell.datefield.text = arrfield_date[indexPath.row]
            myCell.name_mnf.text = arrMNF_name[indexPath.row]
            myCell.size_mnf.text = arrMNF_size[indexPath.row]
            
            myCell.tapAction = { [weak self] (cell) in
                
                self!.passField_id = self!.arrfield_id[indexPath.row]
                self!.passminiField_id = self!.arrMNF_id[indexPath.row]
                self?.More()
            }
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + arrMNF_image[indexPath.row]
            var urlimgfield = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + arrfield_image[indexPath.row]
            
            
            if urlImage.isEmpty {
                myCell.ImageView.image = UIImage(named: "picture")
            }else {
                
                downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                    
                    if image == nil {
                        myCell.ImageView.image = UIImage(named: "picture")
                        
                    }else {
                        
                        myCell.ImageView.image = image
                        myCell.ImageView.contentMode = .ScaleAspectFill
                        myCell.ImageView.layer.borderWidth = 1.0
                        myCell.ImageView.layer.borderColor = UIColor.whiteColor().CGColor;
                        myCell.ImageView.layer.masksToBounds = false
                        myCell.ImageView.layer.cornerRadius = 10
                        myCell.ImageView.clipsToBounds = true
                        
                    }
                }
                
            }
            
            if urlimgfield.isEmpty {
                
                myCell.imageFieldview.image = UIImage(named: "team")
                
            }else {
                
                downloadImage(urlimgfield) { (image) in //เรียก เมอธอทดึงรูป
                    
                    if image == nil {
                        myCell.imageFieldview.image = UIImage(named: "team")
                        
                    }else {
                        
                        myCell.imageFieldview.image = image
                        myCell.imageFieldview.contentMode = .ScaleAspectFill
                        myCell.imageFieldview.layer.borderWidth = 1.5
                        myCell.imageFieldview.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                        myCell.imageFieldview.layer.masksToBounds = false
                        myCell.imageFieldview.layer.cornerRadius = myCell.imageFieldview.frame.height/2
                        myCell.imageFieldview.clipsToBounds = true
                        
                    }
                }
                
            }
            
        }
        else {
            
            print("Internet connection FAILED")
            tableView.reloadData()
            //            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
        return myCell
        
    }
    
    
}

class bookingUI: UITableViewCell {
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var imageFieldview: UIImageView!
    
    @IBOutlet weak var name_mnf: UILabel!
    @IBOutlet weak var size_mnf: UILabel!
    
    
    @IBOutlet weak var datefield: UILabel!
    @IBOutlet weak var namefield: UILabel!
    @IBAction func ActionControl(sender: AnyObject) {
        
        tapAction?(self)
        
    }
    
}