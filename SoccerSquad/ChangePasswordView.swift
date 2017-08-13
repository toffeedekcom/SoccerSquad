//
//  ChangePasswordView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/11/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordView: UITableViewController {

    
    var uidPass = ""
    var chPass = ""
    var getPass = ""
    var newPass = ""
    @IBOutlet weak var oldpass: UITextField!
    @IBOutlet weak var newpass: UITextField!
    @IBOutlet weak var confirmpass: UITextField!
    @IBAction func Done(sender: AnyObject) {
        
        if newpass.text != confirmpass.text {
            
            MyAlerts("Password not match.")
        }else if newpass.text == "" {
            MyAlerts("Please enter your Password.")
        }else if confirmpass.text == "" {
            MyAlerts("Please enter your confirm Password.")
        }else if oldpass.text == "" {
            MyAlerts("Please enter your old Password.")
        }else if oldpass.text != chPass {
            MyAlerts("Old email address incorrent!")
        }else {
            //Success
            self.updatePassword()
            self.oldpass.text = ""
            self.newpass.text = ""
            self.confirmpass.text = ""
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
    }
    func updatePassword() {
        Activity().showLoading()
        
        self.getPass = self.newpass.text!
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateEmail.php"
        
        var parameter:[String:String] = ["uid": uidPass, "email": getPass, "tag": "2"]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.newPass = (value["upassword"] as? String)!
                    
                }
                self.chPass = self.newPass
                print(self.chPass)
                Activity().hideLoading()
        }
        
        
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    

}
