//
//  settingField.swift
//  Project2
//
//  Created by Jay on 7/3/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class settingField: UITableViewController {
    
    var FieldID = ""
    var uid = ""
    
    var namefield = ""
    var countfield = ""
    var openfield = ""
    var closefield = ""
    var streetfield = ""
    var cityfield = ""
    var country = ""
    var zipfield = ""
    var pricefield = ""
    var telfield = ""
    var imagefield = ""
    var latitude = ""
    var longtitude = ""
    var statusField = "ON"
    var status = ""
    var arrStatus = [String]()
    
    
    var updateLatitude = ""
    var updateLongtitude = ""
    
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func Switching(sender: UISwitch) {
        
        if mySwitch.on {
            print("ON")
            self.statusField = "ON"
            //Check connected network
            let net = NetworkReachabilityManager()
            net?.startListening()
            
            net?.listener = {status in
                
                if  net?.isReachable ?? false {
                    
                    if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                        self.updateStatus()
                    }else if(net?.isReachableOnWWAN)! {
                        self.updateStatus()
                    }else {
                        print("unknow")
                    }
                }
                else {
                    self.MyAlerts("No internet connnection")
                    print("no connection")
                }
                
            }

            
            
        } else {
            print("OFF")
            
            let alertController = UIAlertController(title: "Alert!", message: "Ara you sure Off field ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                self.statusField = "OFF"
                //Check connected network
                let net = NetworkReachabilityManager()
                net?.startListening()
                
                net?.listener = {status in
                    
                    if  net?.isReachable ?? false {
                        
                        if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                            self.updateStatus()
                        }else if(net?.isReachableOnWWAN)! {
                            self.updateStatus()
                        }else {
                            print("unknow")
                        }
                    }
                    else {
                        self.MyAlerts("No internet connnection")
                        print("no connection")
                    }
                    
                }

            })
            
            let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in

                self.statusField = "ON"
                self.mySwitch.setOn(true, animated:true)
            })
            
            alertController.addAction(okAction)
            alertController.addAction(deleteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
            alertController.view.layer.cornerRadius = 25
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "editfield" {
            let destination = segue.destinationViewController as! editFieldController
            destination.namefield = self.namefield
            destination.streetfield = self.streetfield
            destination.cityfield = self.cityfield
            destination.country = self.country
            destination.zipfield = self.zipfield
            destination.telfield = self.telfield
            destination.pricefield = self.pricefield
            destination.openfield = self.openfield
            destination.closefield = self.closefield
            destination.latitude = self.latitude
            destination.longtitude = self.longtitude
            destination.imagefield = self.imagefield
            
            
        }else if segue.identifier == "createsubfieldop" {
            let desVC = segue.destinationViewController as! createSubfield
            desVC.id = self.FieldID            
            
        }else if segue.identifier == "managesubfield" {
            let desVC = segue.destinationViewController as! removeSubfield
            desVC.fid = self.FieldID
        }else if segue.identifier == "commentsfield" {
            let desVC = segue.destinationViewController as! NEW_Comments
            desVC.fid = self.FieldID
            desVC.uid1 = self.uid
        }else {
            print("Unknow segue")
        }
    }
    
    @IBAction func unwindToFieldOption(segue:UIStoryboardSegue) {
        print("back Field Options")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    if self.status == "OFF" {
                        
                        self.mySwitch.setOn(false, animated: true);
                    }
                }else if(net?.isReachableOnWWAN)! {

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
    
    
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }

    func updateStatus() {
        
        Activity().showLoading()
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateStatusField.php"
        var parameter:[String:String] = ["fid":FieldID,"status": statusField]
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                Activity().hideLoading()
                print("Success")
           
            }
    }
}
