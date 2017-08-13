//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/30/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Alamofire
var username = ""
var password = ""
var email = ""


 class SignUpViewController:UIViewController  {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var mode = ""
    var userId = ""
   
    
    
    override  public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction  func signUpAction(sender: AnyObject) {
        
        
    var uu1 = usernameField!.text!
        
      
            
          username = usernameField!.text!
         password = passwordField!.text!
          email = emailField!.text!
        
        var  sing  = [username, password, email]
       
        var finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
              
        // Validate the text fields
        if username.characters.count < 5 {
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password.characters.count < 8 {
            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email.characters.count < 8 {
            var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else {
//                        var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
//            
          
            let url = "https://nickgormanacademy.com/soccerSquat/SingUp_insert.php"
            let parame:[String:String] = ["username": username, "password": password, "email":email, "mode":self.mode]
            Alamofire.request(.GET,url, parameters: parame ,encoding: .URL).validate()
                .responseJSON{(response) in
                                var JSON = [AnyObject]()
                                JSON = response.result.value as! [AnyObject]!
                                for value in JSON {
                                        self.userId  = (value["uid"] as? String)!
                       
                                }
                    print("uid = \(self.userId)")
                    
                            }
            

            
            
        }
        
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mode")
//            self.presentViewController(viewController, animated: true, completion: nil)
//        })
    }
    
   
    
 
}





