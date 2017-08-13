//
//  searchFieldView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/13/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class searchFieldView: UITableViewController, UISearchResultsUpdating {

    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredAppleProducts = [String]()
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
    
    var indexPath = 0
    
    var nameowner = ""
    var imageowner = ""
    var date = ""
    
    
    var arrName = [String]()
    var arrImage = [String]()
    var arrDate = [String]()
    var checkName = [String]()
    
    var pass_fieldid = ""
    var pass_name = ""
    var pass_cityfield = ""
    var pass_imagefield = ""
    var pass_countryfield = ""
    var pass_arrZip = ""
    var pass_arrStreet = ""
    var pass_arrTel = ""
    var pass_pricefield = ""
    var pass_openfield = ""
    var pass_closefield = ""
    var pass_arrLatitude = ""
    var pass_arrLongtitude = ""
    var pass_arrStatus = ""
    var pass_userid = ""
    var pass_arrName = ""
    var pass_arrImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.resultSearchController.searchBar.barTintColor = UIColor.whiteColor()
        self.resultSearchController.searchBar.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.refreshControl?.addTarget(self, action: #selector(searchFieldView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.reloadData()
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.selectField()
                }else if(net?.isReachableOnWWAN)! {
                    self.selectField()
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
    
    override func viewDidAppear(animated: Bool) {
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.selectField()
                }else if(net?.isReachableOnWWAN)! {
                    self.selectField()
                }else {
                    print("unknow")
                }
            }
            else {
                self.MyAlerts("No internet connnection")
                print("no connection")
            }
            
        }

        self.tableView.reloadData()
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.name as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
        
    }
    
    func selectField() {
        Activity().showLoading()
        let urlSelectField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedField.php"
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
                
                if response.result.value == nil {
                    print("Not found data")
                }
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
                self.tableView.reloadData()
                
        }
        
        Activity().hideLoading()

        
    }


    func handleRefresh(refreshControl: UIRefreshControl) {
        
        selectField()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.resultSearchController.active {
            // addNamePlayer = filteredAppleProducts
            return self.filteredAppleProducts.count
            
        }
        else{
            
            return self.name.count
            
            
        }    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchfieldcell", forIndexPath: indexPath) as! searchFieldCell
        
        
        if self.resultSearchController.active {
            cell.field.text = self.filteredAppleProducts[indexPath.row]
            cell.date.text = arrDate[indexPath.row]
            cell.status.text = arrStatus[indexPath.row]
            if cell.status.text == "ON" {
                cell.customStatusOpen()
            }else {
                cell.customStatusClose()
            }
            cell.status.hidden = true
            cell.ImageView.hidden = true
            checkName = filteredAppleProducts
        }
        else {
            cell.ImageView.hidden = false
            cell.status.hidden = false
            checkName = name
            cell.field.text = name[indexPath.row]
            cell.date.text = arrDate[indexPath.row]
            cell.status.text = arrStatus[indexPath.row]
            if cell.status.text == "ON" {
                cell.customStatusOpen()
            }else {
                cell.customStatusClose()
            }
            var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + imagefield[indexPath.row]
            
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell.ImageView.image = image
                cell.ImageView.contentMode = .ScaleAspectFill
                cell.ImageView.layer.borderWidth = 1.0
                cell.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                cell.ImageView.layer.masksToBounds = false
                cell.ImageView.layer.cornerRadius = cell.ImageView.frame.size.height/2
                cell.ImageView.clipsToBounds = true
            }
            
        }
        
        
        
        
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        let index:Int = name.indexOf(checkName[indexPath.row] )!
        
        self.pass_fieldid = fieldid[index]
        self.pass_name = name[index]
        self.pass_cityfield = cityfield[index]
        self.pass_imagefield = imagefield[index]
        self.pass_countryfield = countryfield[index]
        self.pass_arrZip = arrZip[index]
        self.pass_arrStreet = arrStreet[index]
        self.pass_arrTel = arrTel[index]
        self.pass_pricefield = pricefield[index]
        self.pass_openfield = openfield[index]
        self.pass_closefield = closefield[index]
        self.pass_arrLatitude = arrLatitude[index]
        self.pass_arrLongtitude = arrLongtitude[index]
        self.pass_arrStatus = arrStatus[index]
        self.pass_userid = userid[index]
        self.pass_arrName = arrName[index]
        self.pass_arrImage = arrImage[index]

        performSegueWithIdentifier("searchfielddetail", sender: self)
    }
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "searchfielddetail") {
            let destinationVC = segue.destinationViewController as! DetailFieldTableViewController
            destinationVC.fieldID = self.pass_fieldid
            destinationVC.namefield = self.pass_name
            destinationVC.cityfield = self.pass_cityfield
            destinationVC.imagefield = self.pass_imagefield
            destinationVC.country = self.pass_countryfield
            destinationVC.zipfield = self.pass_arrZip
            destinationVC.streetfield = self.pass_arrStreet
            destinationVC.telfield = self.pass_arrTel
            destinationVC.pricefield = self.pass_pricefield
            destinationVC.openfield = self.pass_openfield
            destinationVC.closefield = self.pass_closefield
            destinationVC.latitude = self.pass_arrLatitude
            destinationVC.longtitude = self.pass_arrLongtitude
            destinationVC.statusfield = self.pass_arrStatus
            
            //Owner
            destinationVC.ownerid = self.pass_userid
            destinationVC.ownefield = self.pass_arrName
            destinationVC.ownerImage = self.pass_arrImage
        }
    }

}

class searchFieldCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var field: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    
    func customStatusOpen() {
        
        status.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        status.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        status.layer.borderWidth = 1.0
        status.layer.cornerRadius = 10
    }
    
    func customStatusClose() {
        status.layer.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        status.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        status.layer.borderWidth = 1.0
        status.layer.cornerRadius = 10
        
    }
    
}
