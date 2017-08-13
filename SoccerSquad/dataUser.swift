//
//  dataUser.swift
//  ParseDemo
//
//  Created by toffee on 6/1/2560 BE.
//  Copyright © 2560 abearablecode. All rights reserved.
//

import UIKit
import Alamofire

class dataUser: UIViewController {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var uid = ""
    
    var uName = ""
    var uPosition = ""
    var uSex = ""
    var uPhone = ""
    var uEmail = ""
    var uImage = ""
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlMember = "https://nickgormanacademy.com/soccerSquat/selectUser.php"
        let parame:[String:String] = ["uid": self.uid ]
        Alamofire.request(.GET, urlMember, parameters: parame, encoding: .URL).validate() //ดึงข้อมูลสมาชิกในทีม
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.uName   = (value["uname"] as? String)!
                    self.uPosition  = (value["uposition"] as? String)!
                    self.uPhone   = (value["uphone"] as? String)!
                    self.uSex  = (value["usex"] as? String)!
                    self.uEmail   = (value["uemail"] as? String)!
                    self.uImage   = (value["uimage"] as? String)!
                    
                }
                self.name.text = self.uName
                self.position.text = self.uPosition
                self.sex.text = self.uSex
                self.phone.text = self.uPhone
                self.email.text = self.uEmail
                var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + self.uImage
                self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                    self.image.image = image
                    
                    self.image.layer.borderWidth = 1.0
                    self.image.layer.masksToBounds = false
                    self.image.layer.borderColor = UIColor.darkGrayColor().CGColor
                    self.image.layer.cornerRadius = self.image.frame.size.height/2
                    self.image.clipsToBounds = true
                }

               
                
        }


        // Do any additional setup after loading the view.
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
