//
//  OwnerviewTableViewController.swift
//  Project2
//
//  Created by Jay on 6/21/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class OwnerviewTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel1: UILabel!
    @IBOutlet weak var detailLabel2: UILabel!
    
    var uid = ""
    var ownefield = ""
    var ownerImage:UIImage?
    var ownerEmail = ""
    var ownerDetail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
            checkUser()
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
        

    
    }
    
    func checkUser() {
        
        self.nameLabel.text = self.ownefield
        self.detailLabel1.text = "Email address: "+self.ownerEmail
        self.detailLabel2.text = "Status: "+self.ownerDetail
        
                if ownerImage == nil {
                    self.imageView.image = UIImage(named: "ChangePicField")
                    
                }else {
                    
                    self.imageView.image = ownerImage
                    self.imageView.contentMode = .ScaleAspectFill
                    self.imageView.layer.borderWidth = 1.0
                    self.imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    self.imageView.layer.masksToBounds = false
                    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
                    self.imageView.clipsToBounds = true
                    
                }

    }
    
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    

}
