//
//  NEW_profile.swift
//  SoccerSquad
//
//  Created by CSmacmini on 7/25/2560 BE.
//  Copyright © 2560 Project. All rights reserved.
//

import UIKit
import Alamofire

class NEW_profile: UITableViewController {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var statusTextView: UITextView!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var count_event: UILabel!
    @IBOutlet weak var count_team: UILabel!
    
    var uid = ""
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        get_data()
    }
    func get_data(){
        
        
        let parame:[String:String] = ["uid": uid ]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/home/getDataUser.php"
        Alamofire.request(.GET,urlSring, parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Empty Data")
                }else {
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    self.name.text  = (value["uname"] as? String)!
                    self.email.text  = (value["uemail"] as? String)!
                    self.sex.text  = (value["usex"] as? String)!
                    self.statusTextView.text = (value["ustatus"] as? String)!
                    self.positionLabel.text = (value["uposition"] as? String)!
                    
                    self.navigationItem.title = self.name.text
                    var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/"+(value["uimage"]as? String)!
                    self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                        self.imageUser.layer.borderWidth = 1.0
                        self.imageUser.layer.masksToBounds = false
                        self.imageUser.contentMode = .ScaleAspectFill
                        self.imageUser.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                        self.imageUser.layer.cornerRadius = self.imageUser.frame.size.height/2
                        self.imageUser.clipsToBounds = true
                        self.imageUser.image = image
                        
                    }
                    
                }
                }
                
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            completion(image)
        }
    }

}
