//
//  changeEmailView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/11/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class changeEmailView: UITableViewController {

    var uidEmail = ""
    var chEmail = ""
    
    var getEmail = ""
    var newEmail = ""
    
    
    @IBOutlet weak var oldemailTextfield: UITextField!
    @IBOutlet weak var newemailTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    
    @IBAction func Done(sender: AnyObject) {
        
        if newemailTextfield.text != confirmTextfield.text {
            
            MyAlerts("Email address not match.")
        }else if newemailTextfield.text == "" {
            MyAlerts("Please enter your email address.")
        }else if confirmTextfield.text == "" {
            MyAlerts("Please enter your confirm email address.")
        }else if oldemailTextfield.text == "" {
            MyAlerts("Please enter your old email address.")
        }else if isValidEmail(oldemailTextfield.text!) == false {
            MyAlerts("Old email address incorrent!")
        }else if isValidEmail(newemailTextfield.text!) == false {
            MyAlerts("New email address incorrent!")
        }else if isValidEmail(confirmTextfield.text!) == false {
            MyAlerts("Confirm email address incorrent!")
        }else if oldemailTextfield.text != chEmail {
            MyAlerts("Old email address incorrent!")
        }else {
            //Success
            self.updateEmail()
            self.oldemailTextfield.text = self.newEmail
            self.newemailTextfield.text = ""
            self.confirmTextfield.text = ""
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        self.oldemailTextfield.text = chEmail
    }
    
    func updateEmail() {
        Activity().showLoading()
        
        self.getEmail = self.newemailTextfield.text!
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateEmail.php"
        
        var parameter:[String:String] = ["uid": uidEmail, "email": getEmail, "tag": "1"]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.newEmail = (value["uemail"] as? String)!
                    
                }
                print(self.newEmail)
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
    
    //Function Checking Email
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
        
    }
}
