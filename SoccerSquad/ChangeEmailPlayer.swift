//
//  ChangeEmailPlayer.swift
//  SoccerSquad
//
//  Created by toffee on 7/24/2560 BE.
//  Copyright © 2560 Project. All rights reserved.
//

import UIKit
import Alamofire

class ChangeEmailPlayer: UITableViewController {
    
    
    @IBOutlet weak var oldEmail: UILabel!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 12
        self.email()
    }
    func email(){
        let url = "https://nickgormanacademy.com/soccerSquat/user/ChackChangeEmail.php"
        var parame:[String:String] = ["uid":userId]
        Alamofire.request(.GET,url,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        self.oldEmail.text = (value["uemail"]as? String)!
                        print("email = \((value["uemail"]as? String)!)")
                    }
                case .Failure(let error):
                    print(error)
                }
        }

    }
    
    @IBAction func changeEmail(sender: AnyObject) {
        
        if (newEmail.text == "" || confirm.text == "") {//เช็คค่าว่างใน newemail confirm
            var alert = UIAlertView(title: "alert", message: "Please Enter a New Email and Confirm Email .", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        }else{
            if(newEmail.text != confirm.text){ //เช็คค่าว่างใน newemail ไม่เท่ากัน confirm
                var alert = UIAlertView(title: "alert", message: "NewEmail And ConfirmEmail No Macth.", delegate: self, cancelButtonTitle: "OK")
                alert.show()

            }else{
                
                let url = "https://nickgormanacademy.com/soccerSquat/user/ChackEmailDuplicate.php"
                var parame:[String:String] = ["email":newEmail.text!]
                Alamofire.request(.GET,url,parameters: parame,encoding: .URL).validate()
                    .responseJSON{(response) in
                        
                        switch response.result {
                        case .Success:
                            var JSON = [AnyObject]()
                            JSON = response.result.value as! [AnyObject]!
                            for value in JSON {
                                print("chackemail = \((value["chackemail"]as? String)!)")
                                if((value["chackemail"]as? String)! == "1"){ //เช็คอีเมลซ้ำ
                                    var alert = UIAlertView(title: "alert", message: "Email Duplicate", delegate: self, cancelButtonTitle: "OK")
                                    alert.show()
                                }
                                else{
                                    
                                    let alertController = UIAlertController(title: "Confirm!", message: "Do You Want ChangePassword", preferredStyle: .Alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                                        
                                        let urlChangeEmail = "https://nickgormanacademy.com/soccerSquat/user/ChangeEmail.php"
                                        var parame:[String:String] = ["uid":userId , "email": self.newEmail.text!]
                                        Alamofire.request(.GET,urlChangeEmail,parameters: parame,encoding: .URL).validate()
                                            .responseJSON{(response) in
                                                
                                        }
                                        
                                    })
                                    
                                    let deleteAction = UIAlertAction(title: "CANCEl", style: .Destructive, handler: {(ACTION) in
                                        
                                    })
                                    
                                    alertController.addAction(okAction)
                                    alertController.addAction(deleteAction)
                                    
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                    alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
                                    alertController.view.layer.cornerRadius = 25
                                }
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            
            }
        
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}
