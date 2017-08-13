//
//  BookingList.swift
//  Soccer Squad
//
//  Created by Jay on 7/11/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class BookingList: UITableViewController {
    
    var indexPath = 0
    var mnf_id = ""
    
    var uid = ""
    var bookid = ""
    var bstart = ""
    var bstop = ""
    var bpledge = ""
    var bdate = ""
    var bstatus = ""
    var bprice = ""
    
    
    var uname = ""
    var uimage = ""
    var utel = ""
    var ugender = ""
    var uemail = ""
    
    
    
    var arrUID = [String]()
    var arrBID = [String]()
    var arrSTART = [String]()
    var arrSTOP = [String]()
    var arrPLEDGE = [String]()
    var arrDATE = [String]()
    var arrSTAUTS = [String]()
    var arrPRICE = [String]()
    
    
    var arrUMANE = [String]()
    var arrUIMAGE = [String]()
    var arrUTEL = [String]()
    var arrUEMAIL = [String]()
    var arrGENDER = [String]()
    
    var chkStauts = ""
    var id = ""
    
    var pass_id = ""
    var pass_name = ""
    var pass_image = ""
    var pass_tel = ""
    var pass_email = ""
    var pass_gender = ""
    var pass_price = ""
    var pass_pledge = ""
    var pass_status = ""
    
    var chk:AnyObject?
    
    @IBAction func clearAll(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure clear all booking ?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
            
            self.clearAllbooking()
        })
        
        let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(deleteAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        alertController.view.layer.cornerRadius = 25
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "detailuserbooking" {
            let desVC = segue.destinationViewController as! DetailView
            desVC.uname = self.pass_name
            desVC.uimage = self.pass_image
            desVC.utel = self.pass_tel
            desVC.ugender = self.pass_gender
            desVC.uemail = self.pass_email
            desVC.bpirce = self.pass_price
            desVC.bpledge = self.pass_pledge
            desVC.bstatus = self.pass_status
            desVC.bookid = self.pass_id
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        tableView.allowsSelection = false
        self.refreshControl?.addTarget(self, action: #selector(BookingList.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.ListAction()
        self.tableView.reloadData()
        
    }
    
    
    
    func ListAction() {
        self.arrUID = []
        self.arrBID = []
        self.arrUMANE = []
        self.arrSTART = []
        self.arrSTOP = []
        self.arrPLEDGE = []
        self.arrDATE = []
        self.arrSTAUTS = []
        self.arrPRICE = []
        self.arrUIMAGE = []
        self.arrUTEL = []
        self.arrUEMAIL = []
        self.arrGENDER = []
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectBook.php"
        var parameter:[String:String] = ["mnf_id": mnf_id]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                self.chk = response.result.value
                if response.result.value == nil {
                    self.MyAlerts("No reservations")
                }else {
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.uid = (value["uid"] as? String)!
                        self.bookid = (value["bookid"] as? String)!
                        self.uname = (value["uname"] as? String)!
                        self.uimage = (value["uimage"] as? String)!
                        self.utel = (value["uphone"] as? String)!
                        self.ugender = (value["usex"] as? String)!
                        self.uemail = (value["uemail"] as? String)!
                        self.bdate = (value["bdate"] as? String)!
                        self.bstart = (value["bstartime"] as? String)!
                        self.bstop = (value["bstoptime"] as? String)!
                        self.bstatus = (value["bstatus"] as? String)!
                        self.bprice = (value["bprice"] as? String)!
                        self.bpledge = (value["bpledge"] as? String)!
                        
                        self.arrUID.append(self.uid)
                        self.arrBID.append(self.bookid)
                        self.arrUMANE.append(self.uname)
                        self.arrUIMAGE.append(self.uimage)
                        self.arrUTEL.append(self.utel)
                        self.arrUEMAIL.append(self.uemail)
                        self.arrGENDER.append(self.ugender)
                        self.arrDATE.append(self.bdate)
                        self.arrSTART.append(self.bstart)
                        self.arrSTOP.append(self.bstop)
                        self.arrSTAUTS.append(self.bstatus)
                        self.arrPRICE.append(self.bprice)
                        self.arrPLEDGE.append(self.bpledge)
                    }
                    self.tableView.reloadData()
                    print(self.arrBID)
                    
                }
        }
        
        
    }
    
    func updateStatus() {
        
        if self.chkStauts == "Waiting" {
            MyAlerts("Unable to update status!")
        }else if self.chkStauts == "Confirm" {
            MyAlerts("Status updated Can not update anymore!")
        }else {
            
            let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateStatusBooking.php"
            var updateStatus = "Confirm"
            let parameter:[String:String] = ["bookid": self.id, "bstatus": updateStatus]
            Activity().showLoading()
            Alamofire.request(.GET, URL, parameters: parameter ,encoding: .URL).validate()
                .responseJSON{(response) in
                    
                    Activity().hideLoading()
                    self.MyAlerts("Confirmation!")
            }
            
        }
        
    }
    
    func CancelBooking() {
        
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/cancelBooking.php"
        
        let parameter:[String:String] = ["bookid": self.id]
        Activity().showLoading()
        Alamofire.request(.GET, URL, parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                Activity().hideLoading()
                self.MyAlerts("Cancel reservation!")
        }
        
    }
    
    func clearAllbooking() {
        
        if self.chk == nil {
            
            self.MyAlerts("Not data all clear")
            
        }else {
            
            let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/clearAllbooking.php"
            
            let parameter:[String:String] = ["mnf_id": self.mnf_id]
            Activity().showLoading()
            Alamofire.request(.GET, URL, parameters: parameter ,encoding: .URL).validate()
                .responseJSON{(response) in
                    
                    Activity().hideLoading()
                    self.MyAlerts("Clear All Success")
            }
        }
    }
    
    func More() {
        let alert = UIAlertController(title: "More",message: "Choose your lists.",preferredStyle: .Alert)
        
        let action0 = UIAlertAction(title: "Detail", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("detailuserbooking", sender: self)
            
            
        })
        
        let action1 = UIAlertAction(title: "Reservation confirmation", style: .Default, handler: { (action) -> Void in
            
            let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure reservation confirmation ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                
                self.updateStatus()
            })
            
            let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
                
            })
            
            alertController.addAction(okAction)
            alertController.addAction(deleteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
            alertController.view.layer.cornerRadius = 25
            
        })
        
        let action2 = UIAlertAction(title: "Cancel reservation", style: .Default, handler: { (action) -> Void in
            
            let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure cancel reservation ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                
                self.CancelBooking()
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
        alert.addAction(action0)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0) // change text color of the buttons
        alert.view.layer.cornerRadius = 25   // change corner radius
        
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        ListAction()
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
        
        return 100
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return arrBID.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("bookinglistCell", forIndexPath: indexPath) as! ListUI
        
            myCell.bookignTimeUI()
            myCell.name.text = arrUMANE[indexPath.row]
            myCell.postbook.text = arrDATE[indexPath.row]
            myCell.booking.text = arrSTART[indexPath.row]+" - "+arrSTOP[indexPath.row]
            myCell.status.text = arrSTAUTS[indexPath.row]
            
            if myCell.status.text == "Waiting" {
                myCell.statusWaitting()
            }else if myCell.status.text == "Success" {
                myCell.statusSuccess()
            }else {
                myCell.statusConfirm()
            }
            
            myCell.tapAction = { [weak self] (myCell) in
                
                self!.pass_id = self!.arrBID[indexPath.row]
                self!.pass_name = self!.arrUMANE[indexPath.row]
                self!.pass_image = self!.arrUIMAGE[indexPath.row]
                self!.pass_tel = self!.arrUTEL[indexPath.row]
                self!.pass_gender = self!.arrGENDER[indexPath.row]
                self!.pass_email = self!.arrUEMAIL[indexPath.row]
                self!.pass_price = self!.arrPRICE[indexPath.row]
                self!.pass_pledge = self!.arrPLEDGE[indexPath.row]
                self!.pass_status = self!.arrSTAUTS[indexPath.row]
                
                self!.chkStauts = self!.arrSTAUTS[indexPath.row]
                self!.id = self!.arrBID[indexPath.row]
                self?.More()
            }
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/"+arrUIMAGE[indexPath.row]
            //            var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/"
            //            var urlimgfield = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/"
            //
            //
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
                        myCell.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                        myCell.ImageView.layer.masksToBounds = false
                        myCell.ImageView.layer.cornerRadius = myCell.ImageView.frame.height/2
                        myCell.ImageView.clipsToBounds = true
                        
                    }
                }
                
            }
        
        
        return myCell
        
    }
    
    
}

class ListUI: UITableViewCell {
    var tapAction: ((UITableViewCell) -> Void)?
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var booking: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var postbook: UILabel!
    @IBAction func more(sender: AnyObject) {
        
        tapAction?(self)
    }
    
    func bookignTimeUI() {
        booking.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        booking.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        booking.layer.borderWidth = 1.0
        booking.layer.cornerRadius = 12
    }
    
    func statusSuccess() {
        status.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        status.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        status.layer.borderWidth = 1.0
        status.layer.cornerRadius = 10
    }
    
    func statusWaitting() {
        status.layer.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        status.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        status.layer.borderWidth = 1.0
        status.layer.cornerRadius = 10
    }
    
    func statusConfirm() {
        status.layer.backgroundColor = UIColor(red:0.04, green:0.77, blue:0.55, alpha:1.0).CGColor
        status.layer.borderColor = UIColor(red:0.04, green:0.77, blue:0.55, alpha:1.0).CGColor
        status.layer.borderWidth = 1.0
        status.layer.cornerRadius = 10
        
    }
    
}
