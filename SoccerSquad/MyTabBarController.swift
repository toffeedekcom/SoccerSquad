//
//  MyTabBarController.swift
//  Soccer Squad
//
//  Created by Jay on 5/25/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit

//var userId = "73"

class MyTabBarController: UITabBarController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Activity().hideLoading()
        
        self.tabBar.hidden = false

    }

}
