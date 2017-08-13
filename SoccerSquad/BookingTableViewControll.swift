//
//  BookingTableViewControll.swift
//  Project2
//
//  Created by Jay on 6/20/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class BookingTableViewControll: UITableViewController{

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    
    let url = ""
    
    @IBOutlet weak var List: UITableViewCell!
    
    func customUI() {
        self.ImageView.contentMode = .ScaleAspectFill
        self.ImageView.layer.borderWidth = 1.0
        self.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        self.ImageView.layer.masksToBounds = false
        self.ImageView.layer.cornerRadius = self.ImageView.frame.size.height/2
        self.ImageView.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
    }
    
}
