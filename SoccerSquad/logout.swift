//
//  logout.swift
//  ParseDemo
//
//  Created by toffee on 18/6/59.
//  Copyright © พ.ศ. 2559 abearablecode. All rights reserved.
//

import Foundation
import UIKit


class logout : UIViewController  {
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    ///////
   
    
    @IBAction func logoutButton(sender: AnyObject) {///ปุ่ม logout
   //     let loginManager  = FBSDKLoginManager()
    
   //     loginManager.logOut()
          self.performSegueWithIdentifier("showlogout", sender: self)
        
    }
            
  

    
    
    
}
