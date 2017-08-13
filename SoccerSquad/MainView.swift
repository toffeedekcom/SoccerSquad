//
//  MainView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/15/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire


class MainView: UIViewController {
    
    var mode = ""
    var userMode = ""
    
    @IBOutlet weak var CustomRegister: UIButton!
    @IBOutlet weak var CustomLogin: UIButton!
    
    @IBOutlet weak var customImage: UIImageView!
    @IBAction func registerAction(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Choose Mode", message: "Please your choose mode.", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in}
        
        
        let ownerAction = UIAlertAction(title: "Owner", style: .Default) { action in
            
            self.mode = "owner"
            self.performSegueWithIdentifier("signUp", sender: self)
            
        }
        
        let playerAction = UIAlertAction(title: "Player", style: .Default) { action in
            
            self.mode = "user"
            self.performSegueWithIdentifier("signUp", sender: self)
            
        }
        
        alertController.addAction(ownerAction)
        alertController.addAction(playerAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {}
        
        alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        alertController.view.layer.cornerRadius = 25
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        print("back Main")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "signUp") {
            let DestViewController = segue.destinationViewController as! RegisterView
            DestViewController.mode = self.mode
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
    }
    
    func customizeUI() {
        
        CustomRegister.layer.borderColor = UIColor.whiteColor().CGColor
        CustomRegister.layer.borderWidth = 1.0
        CustomRegister.layer.cornerRadius = 18
        CustomLogin.layer.cornerRadius = 18
        
        customImage.layer.borderWidth = 1.0
        customImage.layer.borderColor = UIColor.whiteColor().CGColor
        customImage.layer.cornerRadius = customImage.frame.height/2
    }
    
    override func viewDidAppear(animated: Bool) {
        Activity().showLoading()
        if (NSUserDefaults.standardUserDefaults().stringForKey("login") != nil) {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let name = defaults.stringForKey("login") {
                
                print("id: \(name)")
                userId = name
                let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectOwner.php"
                var parameter:[String:String] = ["uid": name]
                Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
                    .responseJSON{(response) in
                        var JSON = [AnyObject]()
                        
                        if response.result.value == nil {
                            self.MyAlerts("No network connection")
                            
                        }else {
                            
                            JSON = response.result.value as! [AnyObject]!
                            for value in JSON {
                                
                                self.userMode = (value["udetail"] as? String)!
                                
                            }
                            print(self.userMode)
                            
                            if self.userMode == "owner" {
                                Activity().hideLoading()
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OwnerTabbar")
                                    self.presentViewController(viewController, animated: true, completion: nil)
                                })
                                
                            }else if self.userMode == "user" {
                                Activity().hideLoading()
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
                                    self.presentViewController(viewController, animated: true, completion: nil)
                                })
                                
                            }else {
                                print("unknow account")
                                Activity().hideLoading()
                            }
                            
                        }
                }
                
            }

            
        }else{
            print("Failed")
            Activity().hideLoading()
        }
        
        Activity().hideLoading()

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
    
}
