//
//  listSubfield.swift
//  Project2
//
//  Created by Jay on 7/4/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class listSubfield: UITableViewController {
    
    var fid = ""
    var subfieldid = ""
    var subfieldtype = ""
    var subfieldsize = ""
    var subfieldimage = ""
    var indexpath = 0
    
    
    var id:[String] = []
    var type:[String] = []
    var size:[String] = []
    var image:[String] = []
    
    @IBAction func createsubfiled(sender: AnyObject) {
        self.performSegueWithIdentifier("createsubfield", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "createsubfield" {
            let destination = segue.destinationViewController as! createSubfield
            destination.id = self.fid
            
        }else {
            print("Unknow segue")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListSubField()
        self.tableView.reloadData()
        self.tableView.separatorColor = UIColor.clearColor()
        
        
    }
    
//    override func viewDidAppear(animated: Bool) {
//        
//        ListSubField()
//        self.tableView.reloadData()
//    }
    
    func ListSubField() {
        let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectSubField.php"
        var parameter:[String:String] = ["fid": fid]
        
        Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.subfieldid = (value["mnf_id"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    self.subfieldtype = (value["mnf_type"] as? String)!
                    self.subfieldsize = (value["mnf_size"] as? String)!
                    self.subfieldimage = (value["mnf_image"] as? String)!

                    self.id.append(self.subfieldid)
                    self.type.append(self.subfieldtype)
                    self.size.append(self.subfieldsize)
                    self.image.append(self.subfieldimage)
                    
                }
                if self.id.isEmpty {
                    let alertController = UIAlertController(title: "Alert!", message: "Do you want to build a sub-field?", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                        self.performSegueWithIdentifier("createsubfield", sender: self)
                    })
                    
                    let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
                    })
                    
                    alertController.addAction(okAction)
                    alertController.addAction(deleteAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
                    alertController.view.layer.cornerRadius = 25

                }
                self.tableView.reloadData()

        }
 
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
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return type.count
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        self.indexpath = indexPath.row
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! OutletSubField
        
        cell.type.text = type[indexPath.row]
        cell.size.text = size[indexPath.row]
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.image[indexPath.row]
        
        cell.ImageView.image = UIImage(named: "picture")
        
        if urlImage.isEmpty {
            cell.ImageView.image = UIImage(named: "picture")
        }else {
            
            self.downloadImage(urlImage) { (image) in
                
                if image == nil {
                    cell.ImageView.image = UIImage(named: "picture")
                    
                }else {
                    
                    cell.ImageView.image = image
                    cell.ImageView.contentMode = .ScaleAspectFill
                    cell.ImageView.layer.borderWidth = 1.0
                    cell.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    cell.ImageView.layer.masksToBounds = false
                    cell.ImageView.layer.cornerRadius = cell.ImageView.frame.size.height/2
                    cell.ImageView.clipsToBounds = true
                    
                }
            }
            
        }

        return cell
    }
    

}
