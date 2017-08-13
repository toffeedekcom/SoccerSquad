//
//  searchTournamentView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/13/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class searchTournamentView: UITableViewController, UISearchResultsUpdating {
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredAppleProducts = [String]()
    var ids = userId
    var tourid = ""
    var tourname = ""
    var tourimage = ""
    var tourdetail = ""
    var tourcount = ""
    var touropen = ""
    var tourclose = ""
    var date = ""
    var fid = ""
    
    var idfield = [String]()
    var idtour = [String]()
    var nametour = [String]()
    var datetour = [String]()
    var imagetour = [String]()
    var detailtour = [String]()
    var counttour = [String]()
    var opentour = [String]()
    var closetour = [String]()
    
    var placeName = ""
    var street_field = ""
    var city_field = ""
    var country_field = ""
    var tel_field = ""
    var image_field = ""
    var latitude_field = ""
    var longtitude_field = ""
    
    var arrStreetField = [String]()
    var arrCityField = [String]()
    var arrCountryField = [String]()
    var arrTelField = [String]()
    var arrImageField = [String]()
    var arrLatitudeField = [String]()
    var arrLongtitudeField = [String]()
    var place = [String]()
    
    var checkName = [String]()
    
    var pass_tourid = ""
    var pass_fieldid = ""
    var pass_tour_name = ""
    var pass_tour_detail = ""
    var pass_tour_count = ""
    var pass_tour_open = ""
    var pass_tour_close = ""
    var pass_tour_image = ""
    
    
    var pass_Fieldname = ""
    var pass_Fieldstreet = ""
    var pass_Fieldcity = ""
    var pass_Fieldcountry = ""
    var pass_Fieldtel = ""
    var pass_Fieldimage = ""
    var pass_Fieldlatitude = ""
    var pass_Fieldlongtitude = ""
    
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
        self.refreshControl?.addTarget(self, action: #selector(searchTournamentView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.separatorColor = UIColor.clearColor()
        self.tableView.reloadData()
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.selectTournament()
                }else if(net?.isReachableOnWWAN)! {
                    self.selectTournament()
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
        let array = (self.nametour as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
        
    }
    
    func selectTournament() {
        let urlSelectEvent = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedEvent.php"
        Activity().showLoading()
        var parameter:[String:String] = ["uid": ids, "segmemt":"0"]
        
        self.idtour = []
        self.nametour = []
        self.datetour = []
        self.imagetour = []
        
        Alamofire.request(.GET,urlSelectEvent ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.tourid = (value["tourid"] as? String)!
                    self.tourname = (value["tourname"] as? String)!
                    self.tourimage = (value["tourimage"] as? String)!
                    self.tourdetail = (value["tourdetail"] as? String)!
                    self.tourcount = (value["tour_count"] as? String)!
                    self.touropen = (value["tour_date"] as? String)!
                    self.tourclose = (value["tour_todate"] as? String)!
                    self.date = (value["dateCurrent"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    
                    self.placeName = (value["fname"] as? String)!
                    self.street_field = (value["fstreet"] as? String)!
                    self.city_field = (value["fcity"] as? String)!
                    self.country_field = (value["fcountry"] as? String)!
                    self.tel_field = (value["fphone"] as? String)!
                    self.image_field = (value["fimage"] as? String)!
                    self.latitude_field = (value["latitude"] as? String)!
                    self.longtitude_field = (value["lontitude"] as? String)!
                    
                    self.idtour.append(self.tourid)
                    self.nametour.append(self.tourname)
                    self.imagetour.append(self.tourimage)
                    self.counttour.append(self.tourcount)
                    self.detailtour.append(self.tourdetail)
                    self.opentour.append(self.touropen)
                    self.closetour.append(self.tourclose)
                    self.datetour.append(self.date)
                    self.idfield.append(self.fid)
                    
                    self.place.append(self.placeName)
                    self.arrStreetField.append(self.street_field)
                    self.arrCityField.append(self.city_field)
                    self.arrCountryField.append(self.country_field)
                    self.arrTelField.append(self.tel_field)
                    self.arrImageField.append(self.image_field)
                    self.arrLatitudeField.append(self.latitude_field)
                    self.arrLongtitudeField.append(self.longtitude_field)
                    
                }
                self.checkName = self.nametour
                self.tableView.reloadData()
                print(self.idtour)
        }
        
        Activity().hideLoading()
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        
        selectTournament()
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
            
            return self.nametour.count
            
            
        }    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchTournamentCell", forIndexPath: indexPath) as! searchTournamentCell
        
        
        if self.resultSearchController.active {
            cell.tournament.text = self.filteredAppleProducts[indexPath.row]
            cell.ImageView.hidden = true
            checkName = filteredAppleProducts
        }
        else {
            cell.ImageView.hidden = false
            checkName = nametour
            cell.tournament.text = nametour[indexPath.row]
            cell.date.text = datetour[indexPath.row]
            var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + imagetour[indexPath.row]
            
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
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        let index:Int = nametour.indexOf(checkName[indexPath.row] )!
        
        
        self.pass_tourid = idtour[index]
        self.pass_fieldid = idfield[index]
        self.pass_tour_name = nametour[index]
        self.pass_tour_detail = detailtour[index]
        self.pass_tour_count = counttour[index]
        self.pass_tour_open = opentour[index]
        self.pass_tour_close = closetour[index]
        self.pass_tour_image = imagetour[index]
        
        self.pass_Fieldname = self.place[index]
        self.pass_Fieldstreet = self.arrStreetField[index]
        self.pass_Fieldcity = self.arrCityField[index]
        self.pass_Fieldcountry = self.arrCountryField[index]
        self.pass_Fieldtel = self.arrTelField[index]
        self.pass_Fieldimage = self.arrImageField[index]
        self.pass_Fieldlatitude = self.arrLatitudeField[index]
        self.pass_Fieldlongtitude = self.arrLongtitudeField[index]
        performSegueWithIdentifier("searchtournamentdetail", sender: self)
    }
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "searchtournamentdetail") {
            let destination = segue.destinationViewController as! EventDetailView
            destination.EventID = self.pass_tourid
            destination.tourid = self.pass_tourid
            destination.Eventname = self.pass_tour_name
            destination.FieldID = self.pass_fieldid
            
            destination.Eventdetail = self.pass_tour_detail
            destination.Eventstart = self.pass_tour_open
            destination.Eventstop = self.pass_tour_close
            destination.Eventimage = self.pass_tour_image
            destination.Field_count = self.pass_tour_count
            
            destination.Fieldname = self.pass_Fieldname
            destination.Fieldstreet = self.pass_Fieldstreet
            destination.Fieldcity = self.pass_Fieldcity
            destination.Fieldcountry = self.pass_Fieldcountry
            destination.Fieldtel = self.pass_Fieldtel
            destination.Fieldimage = self.pass_Fieldimage
            destination.Fieldlatitude = self.pass_Fieldlatitude
            destination.Fieldlongtitude = self.pass_Fieldlongtitude
            
        }
    }
    
    
}

class searchTournamentCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var tournament: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
}
