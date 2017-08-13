//
//  FieldViewController.swift
//  Soccer Squad
//
//  Created by Jay on 5/22/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FieldViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //SegmantController
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    //Table View
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func searchField(sender: AnyObject) {
        self.performSegueWithIdentifier("searchfield", sender: self)
    }
    
    let urlSelectField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedField.php"
    var ids = userId
    
    var id = ""
    var fid = ""
    var fname = ""
    var fopen = ""
    var fcloe = ""
    var fprice = ""
    var fimage = ""
    var city = ""
    var country = ""
    var ownerName = ""
    var status = ""
    var fstreet = ""
    var fzip = ""
    var ftel = ""
    var flatitude = ""
    var flongtitude = ""
    
    
    
    
    
    
    
    var name = [String]()
    var userid = [String]()
    var fieldid = [String]()
    var imagefield = [String]()
    var openfield = [String]()
    var closefield = [String]()
    var cityfield = [String]()
    var countryfield = [String]()
    var pricefield = [String]()
    var Owner = [String]()
    var arrStatus = [String]()
    var arrStreet = [String]()
    var arrZip = [String]()
    var arrTel = [String]()
    var arrLatitude = [String]()
    var arrLongtitude = [String]()
    
    
    
    var listName = [String]()
    var images = [String]()
    var types = [String]()
    
    var nameowner = ""
    var imageowner = ""
    var date = ""
    
    
    var arrName = [String]()
    var arrImage = [String]()
    var arrDate = [String]()
    
    var pass_fieldid = ""
    var pass_fieldname = ""
    var pass_fieldcity = ""
    var pass_fieldcountry = ""
    var pass_fieldimage = ""
    var pass_fieldstreet = ""
    var pass_fieldzip = ""
    var pass_fieldtel = ""
    var pass_fieldprice = ""
    var pass_fieldlatitude = ""
    var pass_fieldlongtitude = ""
    var pass_fieldopen = ""
    var pass_fieldclose = ""
    var pass_fieldstatus = ""
    
    var pass_userid = ""
    var pass_username = ""
    var pass_userimage = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if (segue.identifier == "showDetailField") {
            
            let destinationVC = segue.destinationViewController as! DetailFieldTableViewController
            //Field
            destinationVC.fieldID = self.pass_fieldid
            destinationVC.namefield = self.pass_fieldname
            destinationVC.cityfield = self.pass_fieldcity
            destinationVC.imagefield = self.pass_fieldimage
            destinationVC.country = self.pass_fieldcountry
            destinationVC.zipfield = self.pass_fieldzip
            destinationVC.streetfield = self.pass_fieldstreet
            destinationVC.telfield = self.pass_fieldtel
            destinationVC.pricefield = self.pass_fieldprice
            destinationVC.openfield = self.pass_fieldopen
            destinationVC.closefield = self.pass_fieldclose
            destinationVC.latitude = self.pass_fieldlatitude
            destinationVC.longtitude = self.pass_fieldlongtitude
            destinationVC.statusfield = self.pass_fieldstatus
            
            //Owner
            destinationVC.ownerid = self.pass_userid
            destinationVC.ownefield = self.pass_username
            destinationVC.ownerImage = self.pass_userimage
        }
        
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FieldViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    @IBAction func unwindToField(segue:UIStoryboardSegue) {
        print("back Field")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.addSubview(self.refreshControl)
        self.myTableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.mySegmentControl.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        self.myTableView.separatorColor = UIColor.clearColor()
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    Activity().showLoading()
                    self.name = []
                    self.userid = []
                    self.imagefield = []
                    self.fieldid = []
                    self.openfield = []
                    self.closefield = []
                    self.cityfield = []
                    self.countryfield = []
                    self.pricefield = []
                    self.arrDate = []
                    self.arrName = []
                    self.arrImage = []
                    self.arrStatus = []
                    self.arrStreet = []
                    self.arrZip = []
                    self.arrTel = []
                    self.arrLatitude = []
                    self.arrLongtitude = []
                    self.getdataField()
                    self.myTableView.reloadData()
                    Activity().hideLoading()
                }else if(net?.isReachableOnWWAN)! {
                    Activity().showLoading()
                    self.name = []
                    self.userid = []
                    self.imagefield = []
                    self.fieldid = []
                    self.openfield = []
                    self.closefield = []
                    self.cityfield = []
                    self.countryfield = []
                    self.pricefield = []
                    self.arrDate = []
                    self.arrName = []
                    self.arrImage = []
                    self.arrStatus = []
                    self.arrStreet = []
                    self.arrZip = []
                    self.arrTel = []
                    self.arrLatitude = []
                    self.arrLongtitude = []
                    self.getdataField()
                    self.myTableView.reloadData()
                    Activity().hideLoading()
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        switch (mySegmentControl.selectedSegmentIndex) {
            
        case 0:
            
            getdataField()
            
            
            break
            
        case 1:
            
            getSegment2()
            
            break
        default:
            
            
            break
        }
        
        
        self.myTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 300
    }
    
    
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            selectedCell.contentView.backgroundColor = UIColor.whiteColor()
    
            self.pass_fieldid = self.fieldid[indexPath.row]
            self.pass_fieldname = self.name[indexPath.row]
            self.pass_fieldcity = self.cityfield[indexPath.row]
            self.pass_fieldimage = self.imagefield[indexPath.row]
            self.pass_fieldcountry = self.countryfield[indexPath.row]
            self.pass_fieldzip = self.arrZip[indexPath.row]
            self.pass_fieldstreet = self.arrStreet[indexPath.row]
            self.pass_fieldtel = self.arrTel[indexPath.row]
            self.pass_fieldprice = self.pricefield[indexPath.row]
            self.pass_fieldopen = self.openfield[indexPath.row]
            self.pass_fieldclose = self.closefield[indexPath.row]
            self.pass_fieldlatitude = self.arrLatitude[indexPath.row]
            self.pass_fieldlongtitude = self.arrLongtitude[indexPath.row]
            self.pass_fieldstatus = self.arrStatus[indexPath.row]
    
            //Owner
            self.pass_userid = self.userid[indexPath.row]
            self.pass_username = self.arrName[indexPath.row]
            self.pass_userimage = self.arrImage[indexPath.row]
    
            print(self.pass_fieldid)
    
            self.performSegueWithIdentifier("showDetailField", sender: self)
        }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return name.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = myTableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! OutletFieldTableViewCell
        Activity().showLoading()
        
        myCell.nameLabel.text = name[indexPath.row]
        myCell.openLabel.text = openfield[indexPath.row]+" - "+closefield[indexPath.row]
        myCell.cityLabel.text = cityfield[indexPath.row] + "," + countryfield[indexPath.row]
        myCell.priceLabel.text = pricefield[indexPath.row]+" /hour"
        
        myCell.NameOwner.text = arrName[indexPath.row]
        myCell.PostDate.text = arrDate[indexPath.row]
        
        var datess = arrDate[indexPath.row]
        
        
        //            let inputFormatter = NSDateFormatter()
        //            inputFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        //
        //            let show = inputFormatter.dateFromString(datess)
        //            inputFormatter.dateFormat = "dd-MM-YYYY HH:mm:ss"
        //            let resultString = inputFormatter.stringFromDate(show!)
        //            print(resultString)
        
        
        if arrStatus[indexPath.row] == "ON" {
            myCell.statusLabel.text = "OPEN"
            myCell.customStatusOpen()
        }else {
            myCell.statusLabel.text = "CLOSE"
            myCell.customStatusClose()
        }
        
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + imagefield[indexPath.row]
        var urlImageOwner = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + arrImage[indexPath.row]
        
        if urlImage.isEmpty {
            myCell.imageViewField.image = UIImage(named: "picture")
        }else {
            
            downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                
                if image == nil {
                    myCell.imageViewField.image = UIImage(named: "picture")
                    
                }else {
                    
                    myCell.imageViewField.image = image
                    myCell.imageViewField.contentMode = .ScaleAspectFill
                    myCell.imageViewField.layer.borderWidth = 1.0
                    myCell.imageViewField.layer.borderColor = UIColor.whiteColor().CGColor;
                    myCell.imageViewField.layer.masksToBounds = false
                    myCell.imageViewField.layer.cornerRadius = 10
                    myCell.imageViewField.clipsToBounds = true
                    
                }
            }
            
        }
        
        if urlImageOwner.isEmpty {
            myCell.ImageOwner.image = UIImage(named: "picture")
        }else {
            
            downloadImage(urlImageOwner) { (image) in //เรียก เมอธอทดึงรูป
                
                if image == nil {
                    myCell.ImageOwner.image = UIImage(named: "picture")
                    
                }else {
                    
                    myCell.ImageOwner.image = image
                    myCell.ImageOwner.contentMode = .ScaleAspectFill
                    myCell.ImageOwner.layer.borderWidth = 1.0
                    myCell.ImageOwner.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    myCell.ImageOwner.layer.masksToBounds = false
                    myCell.ImageOwner.layer.cornerRadius = myCell.ImageOwner.frame.height/2
                    myCell.ImageOwner.clipsToBounds = true
                    
                }
            }
            
        }
        
        
        Activity().hideLoading()
        return myCell
    }
    
    
    //Segment Action
    @IBAction func SegmentadControlActionChanged(sender: AnyObject) {
        //reload Data in table view
        switch (mySegmentControl.selectedSegmentIndex) {
            
        case 0:
            self.navigationItem.title = "All Fields"
            self.name = []
            self.userid = []
            self.imagefield = []
            self.fieldid = []
            self.openfield = []
            self.closefield = []
            self.cityfield = []
            self.countryfield = []
            self.pricefield = []
            self.arrDate = []
            self.arrName = []
            self.arrImage = []
            self.arrStatus = []
            self.arrStreet = []
            self.arrZip = []
            self.arrTel = []
            self.arrLatitude = []
            self.arrLongtitude = []
            getdataField()
            
            break
            
        case 1:
            
            self.navigationItem.title = "My Fields"
            self.name = []
            self.userid = []
            self.imagefield = []
            self.fieldid = []
            self.openfield = []
            self.closefield = []
            self.cityfield = []
            self.countryfield = []
            self.pricefield = []
            self.arrDate = []
            self.arrName = []
            self.arrImage = []
            self.arrStatus = []
            self.arrStreet = []
            self.arrZip = []
            self.arrTel = []
            self.arrLatitude = []
            self.arrLongtitude = []
            getSegment2()
            
            break
        default:
            
            
            break
        }
    }
    
    
    
    //Load Item
    
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            completion(image_Field)
        }
    }
    
    func getdataField() {
        Activity().showLoading()
        var parameter:[String:String] = ["uid": ids, "segmemt":"0"]
        self.name = []
        self.userid = []
        self.imagefield = []
        self.fieldid = []
        self.openfield = []
        self.closefield = []
        self.cityfield = []
        self.countryfield = []
        self.pricefield = []
        self.arrDate = []
        self.arrName = []
        self.arrImage = []
        self.arrStatus = []
        self.arrStreet = []
        self.arrZip = []
        self.arrTel = []
        self.arrLatitude = []
        self.arrLongtitude = []
        Alamofire.request(.GET,urlSelectField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                switch response.result {
                case .Success:
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        
                        self.id  = (value["uid"] as? String)!
                        self.fid  = (value["fid"] as? String)!
                        self.fname = (value["fname"] as? String)!
                        self.fimage = (value["fimage"] as? String)!
                        self.fopen = (value["ftime_in"] as? String)!
                        self.fcloe = (value["ftime_out"] as? String)!
                        self.city = (value["fcity"] as? String)!
                        self.country = (value["fcountry"] as? String)!
                        self.fprice = (value["fprice"] as? String)!
                        self.date = (value["fdate"] as? String)!
                        self.nameowner = (value["uname"] as? String)!
                        self.imageowner = (value["uimage"] as? String)!
                        self.status = (value["fstatus"] as? String)!
                        self.fstreet = (value["fstreet"] as? String)!
                        self.ftel = (value["fphone"] as? String)!
                        self.fzip = (value["fzip"] as? String)!
                        self.flatitude = (value["latitude"] as? String)!
                        self.flongtitude = (value["lontitude"] as? String)!
                        
                        self.name.append(self.fname)
                        self.userid.append(self.id)
                        self.fieldid.append(self.fid)
                        self.imagefield.append(self.fimage)
                        self.openfield.append(self.fopen)
                        self.closefield.append(self.fcloe)
                        self.cityfield.append(self.city)
                        self.countryfield.append(self.country)
                        self.pricefield.append(self.fprice)
                        self.arrDate.append(self.date)
                        self.arrName.append(self.nameowner)
                        self.arrImage.append(self.imageowner)
                        self.arrStatus.append(self.status)
                        self.arrStreet.append(self.fstreet)
                        self.arrTel.append(self.ftel)
                        self.arrZip.append(self.fzip)
                        self.arrLatitude.append(self.flatitude)
                        self.arrLongtitude.append(self.flongtitude)
                    }
                    
                    self.myTableView.reloadData()
                    if self.fieldid.isEmpty {
                        self.MyAlerts("You have no Field. Would you like to create a Field?")
                    }
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
                
        }
        
        Activity().hideLoading()
    }
    
    
    
    func getSegment2() {
        Activity().showLoading()
        var parameter:[String:String] = ["uid": ids, "segmemt":"1"]
        self.name = []
        self.userid = []
        self.imagefield = []
        self.fieldid = []
        self.openfield = []
        self.closefield = []
        self.cityfield = []
        self.countryfield = []
        self.pricefield = []
        self.arrDate = []
        self.arrName = []
        self.arrImage = []
        self.arrStatus = []
        self.arrStreet = []
        self.arrZip = []
        self.arrTel = []
        self.arrLatitude = []
        self.arrLongtitude = []
        Alamofire.request(.GET,urlSelectField ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                switch response.result {
                case .Success:
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.id  = (value["uid"] as? String)!
                        self.fid  = (value["fid"] as? String)!
                        self.fname = (value["fname"] as? String)!
                        self.fimage = (value["fimage"] as? String)!
                        self.fopen = (value["ftime_in"] as? String)!
                        self.fcloe = (value["ftime_out"] as? String)!
                        self.city = (value["fcity"] as? String)!
                        self.country = (value["fcountry"] as? String)!
                        self.fprice = (value["fprice"] as? String)!
                        self.date = (value["fdate"] as? String)!
                        self.nameowner = (value["uname"] as? String)!
                        self.imageowner = (value["uimage"] as? String)!
                        self.status = (value["fstatus"] as? String)!
                        self.fstreet = (value["fstreet"] as? String)!
                        self.ftel = (value["fphone"] as? String)!
                        self.fzip = (value["fzip"] as? String)!
                        self.flatitude = (value["latitude"] as? String)!
                        self.flongtitude = (value["lontitude"] as? String)!
                        
                        
                        self.name.append(self.fname)
                        self.userid.append(self.id)
                        self.fieldid.append(self.fid)
                        self.imagefield.append(self.fimage)
                        self.openfield.append(self.fopen)
                        self.closefield.append(self.fcloe)
                        self.cityfield.append(self.city)
                        self.countryfield.append(self.country)
                        self.pricefield.append(self.fprice)
                        self.arrDate.append(self.date)
                        self.arrName.append(self.nameowner)
                        self.arrImage.append(self.imageowner)
                        self.arrStatus.append(self.status)
                        self.arrStreet.append(self.fstreet)
                        self.arrTel.append(self.ftel)
                        self.arrZip.append(self.fzip)
                        self.arrLatitude.append(self.flatitude)
                        self.arrLongtitude.append(self.flongtitude)
                    }
                    self.myTableView.reloadData()
                    
                    if self.fieldid.isEmpty {
                        self.MyAlerts("You have no Field. Would you like to create a Field?")
                    }
                    
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
                
        }
        
        Activity().hideLoading()
    }
}