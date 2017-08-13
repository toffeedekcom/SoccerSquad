//
//  Mode_SingUp.swift
//  ParseDemo
//
//  Created by toffee on 10/13/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit

import Foundation
import Alamofire

//var xx1 = Mode_SingUp()
//var yy = SignUpViewController()


class Mode_SingUp :UIViewController {
   
    
 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     
        
              // Do any additional setup after loading the view.
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func kk(test: String) {
    var str = test
   
   var  ll = test
    
  
    
    
    }
   
    
    @IBAction func Owner(sender: AnyObject) {
        
    
        
        
        
    }
    
    ////////////////////////////////////////////////////////////////////////
    
    @IBAction func User(sender: AnyObject) {
    
        
        
//print(">>>>>>--\(ll)")
      
  
       
       let username1 = ""
        let password1 = ""
        let email1 = ""
        
        let data = HomeViewController()
        
        let url = "https://nickgormanacademy.com/soccerSquat/SingUp_insert.php"
                 let parame:[String:String] = ["a": username1, "b": password1, "c":email1]
                Alamofire.request(.GET,url, parameters: parame ,encoding: .URL).validate()
        
                    .responseJSON{(response) in
                        print("love_you1")
                        var JSON = [AnyObject]()
                        
                      
                        print("love_you2")
                       // data.userNameLabel.text = data.creck_logi
                        
                }
        
        var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
        alert.show()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
            self.presentViewController(viewController, animated: true, completion: nil)
        })

        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


