//
//  UpDate_DataUser.swift
//  ParseDemo
//
//  Created by toffee on 10/31/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary

class UpDate_DataUser: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var imageUser: UIImageView!
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var btn: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.btn.layer.cornerRadius = 12
        let url = "https://nickgormanacademy.com/soccerSquat/selectUser.php"
        let parame:[String:String] = ["uid": userId]
        
        Alamofire.request(.GET,url, parameters: parame, encoding: .URL).validate()
            
            .responseJSON{(response) in
                //print("love_you1")
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    var tt = (value["uname"] as? String)!
                    
                    self.name.text  = (value["uname"] as? String)!
                    self.phone.text  = (value["uphone"] as? String)!
                    self.password.text  = (value["upassword"] as? String)!
                    self.sex.text  = (value["usex"] as? String)!
                    self.position.text  = (value["uposition"] as? String)!
                    self.email.text  = (value["uemail"] as? String)!
                    
                    
                  var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + (value["uimage"] as? String)!
                    

                    self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                        self.imageUser.image = image
                        //self.imageUser.contentMode = .ScaleAspectFit
                        self.imageUser.layer.borderWidth = 1.0
                        self.imageUser.layer.masksToBounds = false
                        self.imageUser.layer.cornerRadius = self.imageUser.frame.size.height/2
                        self.imageUser.clipsToBounds = true
                    }

                    
                    
                    
                    
                    print("name\(tt)")
                    
                    
                }
                
                
                
                
                // Do any additional setup after loading the view.
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func Save_Data_Update(sender: AnyObject) {
        print(">>>>>>\(userId)")

        var name1 = self.name.text!
         var phone = self.phone.text!
         var password = self.password.text!
         var sex = self.sex.text!
        var email = self.email.text!
         var position = self.position.text!
        
        
        
        let url = "https://nickgormanacademy.com/soccerSquat/UpDate_DataUser.php"
        let parame:[String:String] = ["user_id": userId, "name": name1 , "phone": phone , "email":email , "position":position , "sex":sex , "password":password]
        
        
        
        Alamofire.upload(.POST, url,headers: parame ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageUser.image!,0.4)! ,name: "file", fileName: "image", mimeType: "singupImage/")
            
            
            for (key, value) in parame {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
            }
            
            } ,  encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { (response) in
                        
                      print("xx")
                        
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
        })
        
        
        var alert = UIAlertView(title: "Success", message: "Edit Success", delegate: self, cancelButtonTitle: "OK")
        alert.show()
       performSegueWithIdentifier("home", sender: self)
        
        
    }
    
   
    @IBAction func buttonPhoto(sender: AnyObject) {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        print(myPickerController.accessibilityPath)
        self.presentViewController(myPickerController, animated: true, completion: nil)

        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageUser.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        // print("nameImage = \()")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    

    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
}

