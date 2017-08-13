//
//  EventLocationTableViewController.swift
//  Project2
//
//  Created by toffee on 6/21/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class EventLocationTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var date = ""
    var nameTeam = ""
    var detail = ""
    var tid = ""
    var nameEvent = ""
    
    var fid = ""
    var nameField = ""
    var nameImageField = ""
    
    var addFid = [String]()
    var addNameField = [String]()
    var addNameImageField = [String]()
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredAppleProducts = [String]()
     var chackName = [String]()//เอาไปหาจำนวน Index เพื่อเอาไปเช็คกับ fid
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
        self.doLacation()
        
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("test...")
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.addNameField as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredAppleProducts.count
        }
        else{
            return self.addNameField.count
 
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? EventLocationCell
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + addNameImageField[indexPath.row]
        
        
        if self.resultSearchController.active {
            cell!.nameField.text = self.filteredAppleProducts[indexPath.row]
            cell!.showImage.hidden = true
            print("name1 \(self.filteredAppleProducts)")
            chackName = filteredAppleProducts
        }
        else {
            cell?.nameField.text = addNameField[indexPath.row]
            cell!.showImage.hidden = false
            chackName = addNameField
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell!.showImage.image = image
                cell!.showImage.contentMode = .ScaleAspectFit
                cell!.showImage.layer.borderWidth = 1.0
                cell!.showImage.layer.masksToBounds = false
                cell!.showImage.layer.cornerRadius = cell!.showImage.frame.size.height/2
                cell!.showImage.clipsToBounds = true
            }
        }
        
        
     
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        
        let index:Int = addNameField.indexOf(chackName[indexPath.row] )!
        self.fid = addFid[index]
        self.nameField = addNameField[index]
        performSegueWithIdentifier("eventlocation", sender: self)
    }
    
    
    
    func doLacation(){
        let urlFieldAll = "https://nickgormanacademy.com/soccerSquat/event/FieldAll.php"
        Alamofire.request(.GET,urlFieldAll  ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.fid  = (value["fid"] as? String)!
                    self.nameField  = (value["fname"] as? String)!
                    self.nameImageField  = (value["fimage"] as? String)!

                    self.addFid.append(self.fid)
                    self.addNameField.append(self.nameField)
                    self.addNameImageField.append(self.nameImageField)

                    self.chackName = self.addNameField
                    
                    
                   
                }
                print(self.addNameImageField)
                self.tableView.reloadData()
                
                
        }

    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "eventlocation") {
//           let navController = segue.destinationViewController as! UINavigationController
//            let DestViewController = navController.topViewController as! CreateEvent
           let DestViewController = segue.destinationViewController as! CreateEvent
            
            DestViewController.nameField = nameField
            DestViewController.fid = fid
            DestViewController.nameMyTeam = nameTeam
            DestViewController.dateEvent = date
            DestViewController.setDetail = detail
            DestViewController.tid = tid
            DestViewController.setNameEvent = nameEvent

           
        }
    }
    

    
    


   
}
