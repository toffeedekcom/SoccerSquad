//
//  BookingField.swift
//  Project2
//
//  Created by toffee on 7/1/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BookingField: UITableViewController, UISearchResultsUpdating {
    
    var nameField = ""
    var imageField = ""
    var fieldId = ""
    var price = ""
    var timeOnOff = ""
    
    var addNameField = [String]()
    var addImageField = [String]()
    var addFieldId = [String]()
    var addPrice = [String]()
    var addTimeOnOff = [String]()
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredAppleProducts = [String]()
    var chackName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.resultSearchController.searchBar.barTintColor = UIColor.whiteColor()
        self.resultSearchController.searchBar.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.tableView.reloadData()


       self.dolistField()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("test...")
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.addNameField as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
        
    }
    
    
    func dolistField() {
        
        let urlFieldAll = "https://nickgormanacademy.com/soccerSquat/booking/FieldBooking.php"
        
        Alamofire.request(.GET,urlFieldAll,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                       
                        self.nameField  = (value["fname"] as? String)!
                        self.imageField  = (value["fimage"] as? String)!
                        self.fieldId = (value["fid"] as? String)!
                        self.price = (value["fprice"] as? String)!
                        self.timeOnOff = (value["fstatus"] as? String)!
                        
                       
                        self.addNameField.append(self.nameField)
                        self.addImageField.append(self.imageField)
                        self.addFieldId.append(self.fieldId)
                        self.addPrice.append(self.price)
                        self.addTimeOnOff.append(self.timeOnOff)
                        
                        
                    }
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }

                
                
        }

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
        // #warning Incomplete implementation, return the number of rows
        
        if self.resultSearchController.active {
            // addNamePlayer = filteredAppleProducts
            return self.filteredAppleProducts.count
            
        }
        else{
            
           return self.addNameField.count
            
            
        }

        
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BookingFieldCell
        cell.viewTime.layer.cornerRadius = 12
        
        
        if self.resultSearchController.active {
            cell.nameField.text = self.filteredAppleProducts[indexPath.row]
            cell.imageField.hidden = true
            cell.viewTime.hidden = true
            print("name1 \(self.filteredAppleProducts)")
            chackName = filteredAppleProducts
        }
        else {
            cell.nameField.text = self.addNameField[indexPath.row]
            cell.imageField.hidden = false
            cell.viewTime.hidden = false
            chackName = addNameField
            
            if(addTimeOnOff[indexPath.row] == "OFF"){
                
                cell.timeOnOff.text = "CLOSE"
                cell.viewTime.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            }else{
                
                cell.timeOnOff.text = "OPEN"
                cell.viewTime.backgroundColor = UIColor(red:0.51, green:0.91, blue:0.59, alpha:1.0)
            }
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + addImageField[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell.imageField.image = image
                cell.imageField.contentMode = .ScaleAspectFill
                cell.imageField.layer.borderWidth = 1.0
                cell.imageField.layer.masksToBounds = false
                cell.imageField.layer.cornerRadius = cell.imageField.frame.size.height/2
                cell.imageField.clipsToBounds = true
            }
            
        }
        

       


        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let index:Int = addNameField.indexOf(chackName[indexPath.row] )!
        print( index)
        print(chackName[indexPath.row] )
        
       

        
        
        self.fieldId = self.addFieldId[index]
        self.price = self.addPrice[index]
        performSegueWithIdentifier("bookingfield", sender: self)
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if (segue.identifier == "bookingfield") {
            let DestViewController = segue.destinationViewController as! DataField
               // let DestViewController = navController.topViewController as! MinifieldBooking
                
    
    
            DestViewController.FieldID = self.fieldId
            DestViewController.price = self.price
                
                
        }
    }
 

   
}
