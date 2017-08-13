//
//  MinifieldBooking.swift
//  Project2
//
//  Created by toffee on 7/1/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MinifieldBooking: UITableViewController {
    
    var memberFieldID = ""
    
    var category = ""
    var imageMemberField = ""
    var memberFieldId = ""
    var size = ""
    var price = ""
    
    
    var addCategory = [String]()
    var addImageMemberField = [String]()
    var addMemberFieldId = [String]()
    var addSize = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

       print("price = \(self.price)")
        self.doListMemberField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doListMemberField() {
        let urlFieldAll = "https://nickgormanacademy.com/soccerSquat/booking/MemberFieldBooking.php"
        var parame:[String:String] = ["mbfId": memberFieldID]
        Alamofire.request(.GET,urlFieldAll,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.category  = (value["mnf_type"] as? String)!
                        self.imageMemberField  = (value["mnf_image"] as? String)!
                        self.memberFieldId = (value["mnf_id"] as? String)!
                        self.size = (value["mnf_size"] as? String)!

                        
                        
                        self.addCategory.append(self.category)
                        self.addImageMemberField.append(self.imageMemberField)
                        self.addMemberFieldId.append(self.memberFieldId)
                        self.addSize.append(self.size)
                        
                        
                    }
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("ddd = \(addCategory)")
        return self.addImageMemberField.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as?
        
        MiniFieldBookingCell
        
        cell!.nameMiniField.text = self.addCategory[indexPath.row]
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + addImageMemberField[indexPath.row]
        
        
        getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
            cell!.imageMiniField.image = image
            cell!.imageMiniField.contentMode = .ScaleAspectFit
            cell!.imageMiniField.layer.borderWidth = 1.0
            cell!.imageMiniField.layer.masksToBounds = false
            cell!.imageMiniField.layer.cornerRadius = cell!.imageMiniField.frame.size.height/2
            cell!.imageMiniField.clipsToBounds = true
        }

        // Configure the cell...

        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.memberFieldId = addMemberFieldId[indexPath.row]
        performSegueWithIdentifier("bookfield", sender: self)
    }
    
    
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "bookfield") {
            let DestViewController = segue.destinationViewController as! Book
            // let DestViewController = navController.topViewController as! MinifieldBooking
            
            
            
            DestViewController.price = self.price
            DestViewController.memberFieldId = self.memberFieldId
            
            
        }
    }

 

   
}
