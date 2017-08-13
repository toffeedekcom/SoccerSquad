//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit

import Alamofire

var uu = ""
var pp = ""



var user_id = ""
var nameUser: String!


class HomeViewController: UIViewController {
   @IBOutlet var userNameLabel: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    var nameImage = ""
    
  
    

    
   
    
//    var creck_logi = ""
//      var inname = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("tabBarHome = \(tabBarController?.selectedIndex)")
        //Set front & Color Navigation title
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Thonburi", size: 20)!]
    
        
       
        
        get_data()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_data(){
    
       
        let parame:[String:String] = ["uid": userId, ]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/home/getDataUser.php"
            Alamofire.request(.GET,urlSring, parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        nameUser  = (value["uname"] as? String)!
                        self.nameImage = (value["uimage"]as? String)!
                    }
                     self.userNameLabel.text = nameUser
                var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/"+self.nameImage
                self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                    
                    self.imageUser.layer.borderWidth = 1.0
                    self.imageUser.layer.masksToBounds = false
                    self.imageUser.layer.borderColor = UIColor.darkGrayColor().CGColor
                    self.imageUser.layer.cornerRadius = self.imageUser.frame.size.height/2
                    self.imageUser.clipsToBounds = true

                    
                    self.imageUser.image = image
                    self.userNameLabel.text = nameUser
                }
            }
        
    
        
    }
    
    

    
       
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            completion(image)
        }
    }

    @IBAction func searchUser(sender: AnyObject) {
        performSegueWithIdentifier("searchuser", sender: self)
    }
    
    
    @IBAction func setting(sender: AnyObject) {
        performSegueWithIdentifier("setting", sender: self)
    }
    
//    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
//    print("update")
//      self.get_data()
//    }
}


