//
//  DataUserComment.swift
//  Project2
//
//  Created by toffee on 7/8/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class DataUserComment: UITableViewController {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    var uid = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
            self.btn.layer.cornerRadius = 12
            self.doDataUserComme()

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    func doDataUserComme(){
        
        let urlMember = "https://nickgormanacademy.com/soccerSquat/selectUser.php"
        let parame:[String:String] = ["uid": self.uid ]
        Alamofire.request(.GET, urlMember, parameters: parame, encoding: .URL).validate() //ดึงข้อมูลสมาชิกในทีม
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.nameUser.text   = (value["uname"] as? String)!
                    self.position.text  = (value["uposition"] as? String)!
                    self.phone.text   = (value["uphone"] as? String)!
                    self.sex.text  = (value["usex"] as? String)!
                    self.email.text   = (value["uemail"] as? String)!
                    //self.uImage   = (value["uimage"] as? String)!
                    
                    var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + (value["uimage"] as? String)!
                    self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                            self.imageUser.image = image
                            self.imageUser.layer.borderWidth = 1.0
                            self.imageUser.layer.masksToBounds = false
                            self.imageUser.layer.borderColor = UIColor.darkGrayColor().CGColor
                            self.imageUser.layer.cornerRadius = self.imageUser.frame.size.height/2
                            self.imageUser.clipsToBounds = true
                    }
                    
                }
                
                
        }

    
    }
    
    @IBAction func comment(sender: AnyObject) {
        
        performSegueWithIdentifier("comment", sender: self)
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "comment") {
            let DestViewController = segue.destinationViewController as! PlayerComment
                DestViewController.uid1 = uid
            
        }
       
        
        
    }
     @IBAction func unwindToDataUser(segue: UIStoryboardSegue) {
    
    }


   
}
