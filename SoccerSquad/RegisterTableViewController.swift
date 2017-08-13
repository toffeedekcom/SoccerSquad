//
//  RegisterTableViewController.swift
//  Project2
//
//  Created by toffee on 6/12/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class RegisterTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var mode = ""
    var imgData: UIImage?
    var userId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("mode1 = \(self.mode)")
       imageView.image = imgData
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.darkGrayColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        
        
        
    }
    
    
    @IBAction func saveSignUp(sender: AnyObject) {
        
        var emailDuplicate = ""
        
        if (nameTextField.text == "") {
            var alert = UIAlertView(title: "Error", message: "Please Enter a Name. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else if (emailTextField.text == ""){
        
            var alert = UIAlertView(title: "Error", message: "Please Enter a Email. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
            
        else if (!isValidEmail(emailTextField.text!)){
            var alert = UIAlertView(title: "Error", message: "Please Enter a Email. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else if (passwordTextField.text == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a Password ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        
        }
        
        else if (confirmPasswordTextField.text == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a ConfirmPassword. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
            
        else if (confirmPasswordTextField.text != ""){
            if (passwordTextField.text! != confirmPasswordTextField.text!) {
                var alert = UIAlertView(title: "Error", message: "username and password are not matched. ", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else{//เงือนไขถูกต้องทุกอย่าง
                    let urlSring = "https://nickgormanacademy.com/soccerSquat/singup/checkEmailDuplicact.php"
                    let parame:[String:String] = ["name": nameTextField.text!, "email": emailTextField.text!, "password": passwordTextField.text!, "mode":self.mode]
                        Alamofire.upload(.POST, urlSring,headers: parame ,multipartFormData: {multipartFormData in
                            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageView.image!,0.4)! ,name: "file", fileName:"file.JPEG", mimeType: "singupImage/")
                
                            for (key, value) in parame {
                                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                            }
                
                            } ,  encodingCompletion: {
                                encodingResult in
                                switch encodingResult {
                                case .Success(let upload, _, _):
                                    upload.responseJSON { (response) in
                                        var JSON = [AnyObject]()
                                        JSON = response.result.value as! [AnyObject]!
                                        for value in JSON {
                                            emailDuplicate = (value["crecklogin"] as? String)!
                                            
                                            if(emailDuplicate == "1"){
                                                var alert = UIAlertView(title: "Invalid", message: "Email Duplicate ", delegate: self, cancelButtonTitle: "OK")
                                                alert.show()
                                            }
                                            else{
                                            
                                                let url = "https://nickgormanacademy.com/soccerSquat/singup/getIdUserSingup.php"
                                                let parame:[String:String] = ["email":self.emailTextField.text!]
                                                Alamofire.request(.GET,url, parameters: parame ,encoding: .URL).validate()
                                                    .responseJSON{(response) in
                                                        var JSON = [AnyObject]()
                                                        JSON = response.result.value as! [AnyObject]!
                                                        for value in JSON {
                                                            self.userId  = (value["uid"] as? String)!
                                                            
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
                                                            self.presentViewController(viewController, animated: true, completion: nil)
                                                        })
                                                        
                                                }
                                                
                                            }
                                            
                                            
                                            
                                        }
                                       
                                        
                                    }
                                case .Failure(let encodingError):
                                    print(encodingError)
                                }
                                
                        })

                
                }
            
        }

        
            
            
               
        
        
        
//        
       
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        print("index = \(indexPath.row)")
        if(indexPath.row == 0){
        performSegueWithIdentifier("selectImage", sender: self)
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool { //check email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if (segue.identifier == "selectImage") {
//            
//            let navController = segue.destinationViewController as! ImageProfileViewController
//            
//            navController.mode = self.mode
//        }
//    }

    

}
