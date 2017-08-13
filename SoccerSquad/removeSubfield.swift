//
//  removeSubfield.swift
//  Project2
//
//  Created by Jay on 7/4/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class removeSubfield: UITableViewController {

    @IBAction func remove(sender: AnyObject) {
        
        if self.id[self.indexpath].isEmpty{
            print("Nil")
        }else {
            print(self.indexpath)
        }
    }
    
    var fid = global_fieldID
    var subfieldid = ""
    var subfieldtype = ""
    var subfieldsize = ""
    var subfieldimage = ""
    var indexpath = 0
    
    
    var id:[String] = []
    var type:[String] = []
    var size:[String] = []
    var image:[String] = []
    
    var pass_id = ""
    var pass_image = ""
    var pass_type = ""
    var pass_size = ""
    
    @IBAction func unwindToListSubfield(segue: UIStoryboardSegue) {
        print("back List sub field")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if  segue.identifier == "editsubfield" {
            let destination = segue.destinationViewController as! NEW_editsubfield
            destination.id = self.pass_id
            destination.image = self.pass_image
            destination.type = self.pass_type
            destination.size = self.pass_size
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor()
        self.refreshControl?.addTarget(self, action: #selector(removeSubfield.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        ListSubField()
        
        print(fid)
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        ListSubField()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func ListSubField() {
        self.id = []
        self.type = []
        self.size = []
        self.image = []
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
                self.tableView.reloadData()
                
        }
        
    }
    
    func getRemoveField() {
        
        var urlRemove = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/removesubfield.php"
        var sid = ""
        var parameter:[String:String] = ["id": self.pass_id]
        
        Alamofire.request(.GET,urlRemove,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                if response.result.value == nil {
                    print("Not found data")
                }
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    sid = (value["fid"] as? String)!
                    
                }
                if sid.isEmpty {
                    print("Remove Success!")
                }else {
                    print("Remove Fail!")
                }
                
        }
        
        
    }
    
    func More() {
        let alert = UIAlertController(title: "Manage sub field",message: "Choose your lists.",preferredStyle: .Alert)
        
        let action0 = UIAlertAction(title: "Edit", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("editsubfield", sender: self)
            
            
        })
        
        let action1 = UIAlertAction(title: "Remove", style: .Default, handler: { (action) -> Void in
            
            let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure remove sub field ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                self.getRemoveField()
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
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0) // change text color of the buttons
        alert.view.layer.cornerRadius = 25   // change corner radius
        
        
    }

    
    //download image in database
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            //print(image)
            completion(image_Field)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 60
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
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()

        self.indexpath = indexPath.row
        
        self.pass_id = self.id[self.indexpath]
        self.pass_type = self.type[self.indexpath]
        self.pass_size = self.size[self.indexpath]
        self.pass_image = self.image[self.indexpath]
        
        self.More()
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("removeCell", forIndexPath: indexPath) as! OutletRemoveSubField
        
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
