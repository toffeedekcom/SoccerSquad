//
//  EventViewController.swift
//  Soccer Squad
//
//  Created by Jay on 5/25/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import Alamofire

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //SegmantController
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    //Table View
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func searchTournament(sender: AnyObject) {
        self.performSegueWithIdentifier("searchTournament", sender: self)
    }
    
    let urlSelectEvent = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedEvent.php"
    var ids = userId
    var id = ""
    var fid = ""
    var tourid = ""
    var tourname = ""
    var tourdetail = ""
    var touropen = ""
    var tourclose = ""
    var tourimage = ""
    var placeName = ""
    var date = ""
    var counttour = ""
    
    
    
    var count_tour = [String]()
    
    var fieldid = [String]()
    var userid = [String]()
    var idtour = [String]()
    var nametour = [String]()
    var imagetour = [String]()
    var opentour = [String]()
    var closetour = [String]()
    var detailtour = [String]()
    var place = [String]()
    var datetime = [String]()
    
    var indexpath = 0
    
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
    
    
    var pass_id_tour = ""
    var pass_name_tour = ""
    var pass_id_user = ""
    var pass_id_field = ""
    var pass_Eventdetail = ""
    var pass_Eventstart = ""
    var pass_Eventstop = ""
    var pass_Eventimage = ""
    var pass_Eventcount = ""
    
    
    var pass_Fieldname = ""
    var pass_Fieldstreet = ""
    var pass_Fieldcity = ""
    var pass_Fieldcountry = ""
    var pass_Fieldtel = ""
    var pass_Fieldimage = ""
    var pass_Fieldlatitude = ""
    var pass_Fieldlongtitude = ""
    
    var timer  = NSTimer()
    var num = 0
    var countNotification = 0
    
    @IBAction func unwindToTournament(segue:UIStoryboardSegue) {
        print("back Tournament")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if (segue.identifier == "showEventDetail") {
            
            let destination = segue.destinationViewController as! EventDetailView
            destination.EventID = self.pass_id_tour
            destination.tourid = self.pass_id_tour
            destination.Eventname = self.pass_name_tour
            destination.chkID = self.pass_id_user
            destination.FieldID = self.pass_id_field
            
            destination.Eventdetail = self.pass_Eventdetail
            destination.Eventstart = self.pass_Eventstart
            destination.Eventstop = self.pass_Eventstop
            destination.Eventimage = self.pass_Eventimage
            destination.Field_count = self.pass_Eventcount
            
            destination.Fieldname = self.pass_Fieldname
            destination.Fieldstreet = self.pass_Fieldstreet
            destination.Fieldcity = self.pass_Fieldcity
            destination.Fieldcountry = self.pass_Fieldcountry
            destination.Fieldtel = self.pass_Fieldtel
            destination.Fieldimage = self.pass_Fieldimage
            destination.Fieldlatitude = self.pass_Fieldlatitude
            destination.Fieldlongtitude = self.pass_Fieldlongtitude
            
        }else {
            print("Unknow segue")
        }
        
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(EventViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.addSubview(self.refreshControl)
        self.myTableView.separatorColor = UIColor.clearColor()
        self.mySegmentControl.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    //do some stuff

                    switch (self.mySegmentControl.selectedSegmentIndex) {
                        
                    case 0:
                        
                        self.navigationItem.title = "All Tournaments"
                        self.idtour = []
                        self.nametour = []
                        self.detailtour = []
                        self.opentour = []
                        self.closetour = []
                        self.place = []
                        self.imagetour = []
                        self.userid = []
                        self.fieldid = [String]()
                        self.datetime = [String]()
                        self.arrStreetField = [String]()
                        self.arrCityField = [String]()
                        self.arrCountryField = [String]()
                        self.arrTelField = [String]()
                        self.arrImageField = [String]()
                        self.arrLatitudeField = [String]()
                        self.arrLongtitudeField = [String]()
                        self.count_tour = []
                        
                        self.getdataEvent()
                        
                        break
                        
                    case 1:
                        
                        self.navigationItem.title = "My Tournaments"
                        self.idtour = []
                        self.nametour = []
                        self.detailtour = []
                        self.opentour = []
                        self.closetour = []
                        self.place = []
                        self.imagetour = []
                        self.userid = []
                        self.fieldid = [String]()
                        self.datetime = [String]()
                        self.arrStreetField = [String]()
                        self.arrCityField = [String]()
                        self.arrCountryField = [String]()
                        self.arrTelField = [String]()
                        self.arrImageField = [String]()
                        self.arrLatitudeField = [String]()
                        self.arrLongtitudeField = [String]()
                        self.count_tour = []
                        self.getSegment2()
                        
                        break
                    default:
                        
                        
                        break
                    }
                    
                    self.myTableView.reloadData()

                }else if(net?.isReachableOnWWAN)! {
                    //do some stuff

                    switch (self.mySegmentControl.selectedSegmentIndex) {
                        
                    case 0:
                        
                        self.navigationItem.title = "All Tournaments"
                        self.idtour = []
                        self.nametour = []
                        self.detailtour = []
                        self.opentour = []
                        self.closetour = []
                        self.place = []
                        self.imagetour = []
                        self.userid = []
                        self.fieldid = [String]()
                        self.datetime = [String]()
                        self.arrStreetField = [String]()
                        self.arrCityField = [String]()
                        self.arrCountryField = [String]()
                        self.arrTelField = [String]()
                        self.arrImageField = [String]()
                        self.arrLatitudeField = [String]()
                        self.arrLongtitudeField = [String]()
                        self.count_tour = []
                        self.getdataEvent()
                        
                        break
                        
                    case 1:
                        
                        self.navigationItem.title = "My Tournaments"
                        self.idtour = []
                        self.nametour = []
                        self.detailtour = []
                        self.opentour = []
                        self.closetour = []
                        self.place = []
                        self.imagetour = []
                        self.userid = []
                        self.fieldid = [String]()
                        self.datetime = [String]()
                        self.arrStreetField = [String]()
                        self.arrCityField = [String]()
                        self.arrCountryField = [String]()
                        self.arrTelField = [String]()
                        self.arrImageField = [String]()
                        self.arrLatitudeField = [String]()
                        self.arrLongtitudeField = [String]()
                        self.count_tour = []
                        self.getSegment2()
                        
                        break
                    default:
                        
                        
                        break
                    }
                    
                    self.myTableView.reloadData()

                }else {
                    print("unknow")
                }
            }
            else {
                self.MyAlerts("No internet connnection")
                print("no connection")
            }
            
        }
        
        
//        var num = 10 //List all Booking
//        let tabArray = self.tabBarController?.tabBar.items as NSArray!
//        let chatTab = tabArray.objectAtIndex(4) as! UITabBarItem
//        if num == 0{
//            chatTab.badgeValue = nil
//        }else{
//            chatTab.badgeValue = "\(num)"
//        }
        
//        self.numberCount()
//        timer.invalidate()
//        timer = NSTimer.scheduledTimerWithTimeInterval(7, target: self, selector: #selector(EventViewController.update), userInfo: nil, repeats: true)

        
    }
    
    func numberCount() {
        var nameTeam = ""
        var addNameTeam = [String]()
        var parameter:[String:String] = ["uid":userId]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectNotification.php"
        Alamofire.request(.GET,urlSring ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    nameTeam  = (value["bookid"] as? String)!
                    addNameTeam.append(nameTeam)
                }
                self.countNotification = addNameTeam.count
                if(self.countNotification > 0){
                    self.tabBarController?.tabBar.items?[4].badgeValue = "\(self.countNotification)"
                }
                
                self.myTableView.reloadData()
                
        }
        
    }
    func update() {
        print("number = \(num)")
        var nameTeam = ""
        var addNameTeam = [String]()
        
        var parameter:[String:String] = ["uid":userId]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectNotification.php"
        Alamofire.request(.GET,urlSring ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    nameTeam  = (value["bookid"] as? String)!
                    addNameTeam.append(nameTeam)
                }
                self.countNotification = addNameTeam.count
                if(self.countNotification > 0){
                    
                    self.tabBarController?.tabBar.items?[4].badgeValue = "\(self.countNotification)"
                    
                }
                self.myTableView.reloadData()
                
        }
        self.num++
    }

    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        switch (mySegmentControl.selectedSegmentIndex) {
            
        case 0:
            
            self.navigationItem.title = "All Tournaments"
            self.idtour = []
            self.nametour = []
            self.detailtour = []
            self.opentour = []
            self.closetour = []
            self.place = []
            self.imagetour = []
            self.userid = []
            self.fieldid = [String]()
            self.datetime = [String]()
            self.arrStreetField = [String]()
            self.arrCityField = [String]()
            self.arrCountryField = [String]()
            self.arrTelField = [String]()
            self.arrImageField = [String]()
            self.arrLatitudeField = [String]()
            self.arrLongtitudeField = [String]()
            self.count_tour = []
            getdataEvent()
            
            break
            
        case 1:
            
            self.navigationItem.title = "My Tournaments"
            self.idtour = []
            self.nametour = []
            self.detailtour = []
            self.opentour = []
            self.closetour = []
            self.place = []
            self.imagetour = []
            self.userid = []
            self.fieldid = [String]()
            self.datetime = [String]()
            self.arrStreetField = [String]()
            self.arrCityField = [String]()
            self.arrCountryField = [String]()
            self.arrTelField = [String]()
            self.arrImageField = [String]()
            self.arrLatitudeField = [String]()
            self.arrLongtitudeField = [String]()
            self.count_tour = []
            getSegment2()
            
            break
        default:
            
            
            break
        }
        
        myTableView.reloadData()
        refreshControl.endRefreshing()
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
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        self.indexpath = indexPath.row
        
        self.pass_id_tour = self.idtour[indexpath]
        self.pass_name_tour = self.nametour[indexpath]
        self.pass_id_user = self.userid[indexpath]
        self.pass_id_field = self.fieldid[indexpath]
        self.pass_Eventdetail = self.detailtour[indexpath]
        self.pass_Eventstart = self.opentour[indexpath]
        self.pass_Eventstop = self.closetour[indexpath]
        self.pass_Eventimage = self.imagetour[indexpath]
        self.pass_Eventcount = self.count_tour[indexpath]
        
        self.pass_Fieldname = self.place[indexpath]
        self.pass_Fieldstreet = self.arrStreetField[indexpath]
        self.pass_Fieldcity = self.arrCityField[indexpath]
        self.pass_Fieldcountry = self.arrCountryField[indexpath]
        self.pass_Fieldtel = self.arrTelField[indexpath]
        self.pass_Fieldimage = self.arrImageField[indexpath]
        self.pass_Fieldlatitude = self.arrLatitudeField[indexpath]
        self.pass_Fieldlongtitude = self.arrLongtitudeField[indexpath]
        
        performSegueWithIdentifier("showEventDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return nametour.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! OutletEventTableViewCell
        
        
        var strDateOpen = opentour[indexPath.row]
        var strDateClose = closetour[indexPath.row]
        
        var slitDateOpen = strDateOpen.characters.split{$0 == " "}.map(String.init)
        var slitDateClose = strDateClose.characters.split{$0 == " "}.map(String.init)
        
        
        myCell.EventnameLabel.text = nametour[indexPath.row]
        myCell.EventplaceLabel.text = place[indexPath.row]
        myCell.datetime.text = datetime[indexPath.row]
        
        myCell.EventdataLabel.text = slitDateOpen[1]
        myCell.dateopen.text = slitDateOpen[0]
        
        myCell.EventTimeClose.text = slitDateClose[1]
        myCell.dateclose.text = slitDateClose[0]
        
        //            myCell.customDateUI()
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + imagetour[indexPath.row]
        
        if urlImage.isEmpty {
            myCell.EventimageView.image = UIImage(named: "calendar-1")
        }else {
            
            downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                
                if image == nil {
                    myCell.EventimageView.image = UIImage(named: "calendar-1")
                    
                }else {
                    
                    myCell.EventimageView.image = image
                    myCell.EventimageView.contentMode = .ScaleAspectFill
                    myCell.EventimageView.layer.borderWidth = 1.0
                    myCell.EventimageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    myCell.EventimageView.layer.masksToBounds = false
                    myCell.EventimageView.layer.cornerRadius = myCell.EventimageView.frame.height/2
                    myCell.EventimageView.clipsToBounds = true
                    
                }
            }
            
        }
        
        return myCell
    }
    
    
    //Segment Action
    @IBAction func SegmentadControlActionChanged(sender: AnyObject) {
        //reload Data in table view
        //reload Data in table view
        switch (mySegmentControl.selectedSegmentIndex) {
            
        case 0:
            
            self.navigationItem.title = "All Tournaments"
            self.idtour = []
            self.nametour = []
            self.detailtour = []
            self.opentour = []
            self.closetour = []
            self.place = []
            self.imagetour = []
            self.userid = []
            self.fieldid = [String]()
            self.datetime = [String]()
            self.arrStreetField = [String]()
            self.arrCityField = [String]()
            self.arrCountryField = [String]()
            self.arrTelField = [String]()
            self.arrImageField = [String]()
            self.arrLatitudeField = [String]()
            self.arrLongtitudeField = [String]()
            self.count_tour = []
            getdataEvent()
            
            break
            
        case 1:
            
            self.navigationItem.title = "My Tournaments"
            self.idtour = []
            self.nametour = []
            self.detailtour = []
            self.opentour = []
            self.closetour = []
            self.place = []
            self.imagetour = []
            self.userid = []
            self.fieldid = [String]()
            self.datetime = [String]()
            self.arrStreetField = [String]()
            self.arrCityField = [String]()
            self.arrCountryField = [String]()
            self.arrTelField = [String]()
            self.arrImageField = [String]()
            self.arrLatitudeField = [String]()
            self.arrLongtitudeField = [String]()
            self.count_tour = []
            getSegment2()
            
            break
        default:
            
            
            break
        }
        
    }
    
    
    func getdataEvent() {
        Activity().showLoading()
        var parameter:[String:String] = ["uid": ids, "segmemt":"0"]
        self.idtour = []
        self.nametour = []
        self.detailtour = []
        self.opentour = []
        self.closetour = []
        self.place = []
        self.imagetour = []
        self.userid = []
        self.fieldid = [String]()
        self.datetime = [String]()
        self.arrStreetField = [String]()
        self.arrCityField = [String]()
        self.arrCountryField = [String]()
        self.arrTelField = [String]()
        self.arrImageField = [String]()
        self.arrLatitudeField = [String]()
        self.arrLongtitudeField = [String]()
        self.count_tour = []
        Alamofire.request(.GET,urlSelectEvent ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.id  = (value["uid"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    self.tourid = (value["tourid"] as? String)!
                    self.tourname = (value["tourname"] as? String)!
                    self.tourdetail = (value["tourdetail"] as? String)!
                    self.touropen = (value["tour_date"] as? String)!
                    self.tourclose = (value["tour_todate"] as? String)!
                    self.tourimage = (value["tourimage"] as? String)!
                    self.date = (value["dateCurrent"] as? String)!
                    self.placeName = (value["fname"] as? String)!
                    self.counttour = (value["tour_count"] as? String)!
                    
                    self.count_tour.append(self.counttour)
                    self.userid.append(self.id)
                    self.fieldid.append(self.fid)
                    self.idtour.append(self.tourid)
                    self.nametour.append(self.tourname)
                    self.detailtour.append(self.tourdetail)
                    self.opentour.append(self.touropen)
                    self.closetour.append(self.tourclose)
                    self.imagetour.append(self.tourimage)
                    self.datetime.append(self.date)
                    self.place.append(self.placeName)
                    
                    self.street_field = (value["fstreet"] as? String)!
                    self.city_field = (value["fcity"] as? String)!
                    self.country_field = (value["fcountry"] as? String)!
                    self.tel_field = (value["fphone"] as? String)!
                    self.image_field = (value["fimage"] as? String)!
                    self.latitude_field = (value["latitude"] as? String)!
                    self.longtitude_field = (value["lontitude"] as? String)!
                    
                    self.arrStreetField.append(self.street_field)
                    self.arrCityField.append(self.city_field)
                    self.arrCountryField.append(self.country_field)
                    self.arrTelField.append(self.tel_field)
                    self.arrImageField.append(self.image_field)
                    self.arrLatitudeField.append(self.latitude_field)
                    self.arrLongtitudeField.append(self.longtitude_field)
                    
                    
                }
                self.myTableView.reloadData()
                print(self.userid)
                
                if self.idtour.isEmpty {
                    
                    self.MyAlerts("You have no tournament. Would you like to create a tournament?")
                    
                }
        }
        
        Activity().hideLoading()
    }
    
    func getSegment2() {
        Activity().showLoading()
        var parameter:[String:String] = ["uid": ids, "segmemt":"1"]
        self.idtour = []
        self.nametour = []
        self.detailtour = []
        self.opentour = []
        self.closetour = []
        self.place = []
        self.imagetour = []
        self.userid = []
        self.fieldid = [String]()
        self.datetime = [String]()
        self.arrStreetField = [String]()
        self.arrCityField = [String]()
        self.arrCountryField = [String]()
        self.arrTelField = [String]()
        self.arrImageField = [String]()
        self.arrLatitudeField = [String]()
        self.arrLongtitudeField = [String]()
        self.count_tour = []
        Alamofire.request(.GET,urlSelectEvent ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.id  = (value["uid"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    self.tourid = (value["tourid"] as? String)!
                    self.tourname = (value["tourname"] as? String)!
                    self.tourdetail = (value["tourdetail"] as? String)!
                    self.touropen = (value["tour_date"] as? String)!
                    self.tourclose = (value["tour_todate"] as? String)!
                    self.tourimage = (value["tourimage"] as? String)!
                    self.date = (value["dateCurrent"] as? String)!
                    self.placeName = (value["fname"] as? String)!
                    self.counttour = (value["tour_count"] as? String)!
                    
                    self.count_tour.append(self.counttour)
                    self.userid.append(self.id)
                    self.fieldid.append(self.fid)
                    self.idtour.append(self.tourid)
                    self.nametour.append(self.tourname)
                    self.detailtour.append(self.tourdetail)
                    self.opentour.append(self.touropen)
                    self.closetour.append(self.tourclose)
                    self.imagetour.append(self.tourimage)
                    self.datetime.append(self.date)
                    self.place.append(self.placeName)
                    
                    self.street_field = (value["fstreet"] as? String)!
                    self.city_field = (value["fcity"] as? String)!
                    self.country_field = (value["fcountry"] as? String)!
                    self.tel_field = (value["fphone"] as? String)!
                    self.image_field = (value["fimage"] as? String)!
                    self.latitude_field = (value["latitude"] as? String)!
                    self.longtitude_field = (value["lontitude"] as? String)!
                    
                    self.arrStreetField.append(self.street_field)
                    self.arrCityField.append(self.city_field)
                    self.arrCountryField.append(self.country_field)
                    self.arrTelField.append(self.tel_field)
                    self.arrImageField.append(self.image_field)
                    self.arrLatitudeField.append(self.latitude_field)
                    self.arrLongtitudeField.append(self.longtitude_field)
                    
                }
                
                self.myTableView.reloadData()
                print(self.userid)
                if self.idtour.isEmpty {
                    
                    self.MyAlerts("You have no tournament. Would you like to create a tournament?")
                    
                }
                Activity().hideLoading()
        }
    }
    
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            completion(image_Field)
        }
    }
}
