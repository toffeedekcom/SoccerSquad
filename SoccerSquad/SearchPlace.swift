//
//  SearchPlace.swift
//  Project2
//
//  Created by CSmacmini on 6/23/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

protocol PlaceDelegate {
    func placeImage(id: String)
    func placeData(name: String)
    func placeID(fieldid: String)
    
}

class SearchPlace: UITableViewController, UISearchResultsUpdating, UINavigationControllerDelegate  {
    
    
    var searchController = UISearchController()
    var resultController = UITableViewController()
    var url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedField.php"
    var uid = userId
    var fid = ""
    var fname = ""
    var ftype = ""
    var fopen = ""
    var fclose = ""
    var fimage = ""
    
    var name = [String]()
    var userid = [String]()
    var fieldid = [String]()
    var typefield = [String]()
    var imagefield = [String]()
    var openfield = [String]()
    var closefield = [String]()
    var Owner = [String]()
    
    var indexPath = 0
    
    var delegate: PlaceDelegate?
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        //        if (segue.identifier == "editlocation") {
        //            (segue.destinationViewController as! createEventTableViewController).delegate = self
        //
        //        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
//        // Setup the Search Controller
//        self.searchController = UISearchController(searchResultsController: self.resultController)
//        self.tableView.tableHeaderView = self.searchController.searchBar
//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        
//        // Setup the Scope Bar
//        //        searchController.searchBar.scopeButtonTitles = ["All Place", "My Place"]
//        
//        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
//        self.searchController.searchBar.barTintColor = UIColor.whiteColor()
//        self.searchController.searchBar.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.tableView.separatorColor = UIColor.clearColor()
        
        selectePlace()
        
        
    }
    
    
    func selectePlace() {
        
        var parameter:[String:String] = ["uid": uid, "segmemt":"1"]
        
        Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                    
                }else {
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        
                        //                    self.id  = (value["uid"] as? String)!
                        self.fid  = (value["fid"] as? String)!
                        self.fname = (value["fname"] as? String)!
                        self.fimage = (value["fimage"] as? String)!
                        self.fopen = (value["ftime_in"] as? String)!
                        self.fclose = (value["ftime_out"] as? String)!
                        
                        self.name.append(self.fname)
                        //                    self.userid.append(self.id)
                        self.fieldid.append(self.fid)
                        self.imagefield.append(self.fimage)
                        self.openfield.append(self.fopen)
                        self.closefield.append(self.fclose)
                        
                        
                    }
                    
                    print(self.name)
                    self.tableView.reloadData()
                }
        }
        
        
        
    }
    
    //Load Item
    
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        self.indexPath = indexPath.row
        self.delegate?.placeData(self.name[self.indexPath])
        self.delegate?.placeImage(self.imagefield[self.indexPath])
        self.delegate?.placeID(self.fieldid[self.indexPath])
        self.performSegueWithIdentifier("unwindToCreateTournament", sender: self)
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return name.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OutletSearchPlaceTableViewCell
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            myCell.nameLabelevent.text = name[indexPath.row]
            myCell.timeLabelevent.text = "Open: "+openfield[indexPath.row]+", Close"+closefield[indexPath.row]
            
            let urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + imagefield[indexPath.row]
            
            if urlImage.isEmpty {
                myCell.imagePlaceView.image = UIImage(named: "ChangePicField")
            }else {
                
                downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                    
                    if image == nil {
                        myCell.imagePlaceView.image = UIImage(named: "ChangePicField")
                        
                    }else {
                        
                        myCell.imagePlaceView.image = image
                        myCell.imagePlaceView.contentMode = .ScaleAspectFill
                        myCell.imagePlaceView.layer.borderWidth = 1.0
                        myCell.imagePlaceView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                        myCell.imagePlaceView.layer.masksToBounds = false
                        myCell.imagePlaceView.layer.cornerRadius = myCell.imagePlaceView.frame.size.height/2
                        myCell.imagePlaceView.clipsToBounds = true
                        
                    }
                }
                
            }
            
            
        }
        else {
            
            print("Internet connection FAILED")
            tableView.reloadData()
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
        
        return myCell
    }
    
    
    
}
