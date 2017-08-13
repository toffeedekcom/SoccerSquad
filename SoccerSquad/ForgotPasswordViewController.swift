//
//  ForgotPasswordViewController.swift
//  Project2
//
//  Created by toffee on 7/14/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class ForgotPasswordViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    var message = ""

    @IBOutlet weak var customButtonUI: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.layer.cornerRadius = 17
        customButtonUI.layer.cornerRadius = 17
    }
    
    @IBAction func btnReset(sender: AnyObject) {
        
               
        var urlForgot = "https://nickgormanacademy.com/soccerSquat/forgotPassword/ForgotPassword.php"
        var parame:[String:String] = ["email": email.text!]
        Alamofire.request(.GET,urlForgot,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                configuration.timeoutIntervalForResource = 10 // seconds
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.message  = (value["message"] as? String)!
                       print("xxxx = \(self.message)")
                        if(self.message == "no"){
                            self.MyAlerts("Your email address invalid. Please try again!")
                        
                        }else{
                            self.MyAlerts("Send a new password to your email address!")
                        }
                        
                        
                        
                    }
                 
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }

}
