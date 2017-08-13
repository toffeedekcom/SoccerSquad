//
//  RegisterView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/15/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

var userId = ""

class RegisterView: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var mode = ""
    var limitLength = 0
    var get_email = ""
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var CustomPhotoButton: UIButton!
    @IBOutlet weak var CustomRegisterButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    
    @IBAction func choosePhotoAction(sender: AnyObject) {
        
        self.imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Picture Profile", message: "Choose a mode", preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                self.imagePickerController.sourceType = .Camera
                self.presentViewController(self.imagePickerController, animated: true, completion: nil)
            }else {
                
                print("Camera not available")
                
            }
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction) in
            
            self.imagePickerController.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil ))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        
        
        if nameTextField.text == "" {
            MyAlerts("Please your enter full name!")
        }else if emailTextField.text == "" {
            MyAlerts("Please your enter email address!")
        }else if passwordTextField.text == "" {
            MyAlerts("Please your enter password!")
        }else if confirmpasswordTextField.text == "" {
            MyAlerts("Please your enter confirm password!")
        }else if passwordTextField.text != confirmpasswordTextField.text {
            MyAlerts("Please enter a password to verify your password!")
        }else if passwordTextField.text?.characters.count < 6 {
            MyAlerts("Please enter a password at least 6 characters in length!")
        }else if ImageView.image == "" {
            MyAlerts("Please your choose profile photo!")
        }else if isValidEmail(emailTextField.text!) == false {
            MyAlerts("Please enter a email address valid!")
        }else {
            
            let net = NetworkReachabilityManager()
            net?.startListening()
            
            net?.listener = {status in
                
                if  net?.isReachable ?? false {
                    
                    if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                        
                        self.chk_email_fb()
                        self.performSegueWithIdentifier("unwindToMain", sender: self)
                        
                    }else if(net?.isReachableOnWWAN)! {
                        
                        self.chk_email_fb()
                        self.performSegueWithIdentifier("unwindToMain", sender: self)
                        
                    }else {
                        
                        print("unknow")
                        
                    }
                }
                else {
                    self.MyAlerts("No internet connnection")
                    print("no connection")
                }
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmpasswordTextField.delegate = self
        
        print(mode)
        
//        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "callbackFunction", userInfo: nil, repeats: true)
        
    }
    
//    internal func callbackFunction() {
//        // do your busines logic
//        print("Hello")
//    }
    
    func chk_email_fb() {
        Activity().showLoading()
        //Check user database
        let urlSring = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectUser.php"
        let parame:[String:String] = ["uemail": self.emailTextField.text!]
        Alamofire.request(.GET,urlSring, parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                switch response.result {
                case .Success:
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.get_email = (value["uemail_fb"] as? String)!
                        
                    }
                    print(self.get_email)
                    
                    if self.get_email == self.emailTextField.text! {
                        
                        self.SyncUser()
                        
                        
                    }else {
                        
                        self.uploadUser()
                    }
                    
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
        
    }
    
    func SyncUser() {
        
        let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/UpdateSyncUser.php"
        let parame:[String:String] = ["uemail_fb":self.get_email, "uemail": self.emailTextField.text!, "password": self.passwordTextField.text!]
        Alamofire.request(.GET,url, parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                Activity().hideLoading()
                print("Sync Success")
      
        }
    }
    
    func uploadUser() {
        
        let urlSring = "https://nickgormanacademy.com/soccerSquat/singup/checkEmailDuplicact.php"
        let parame:[String:String] = ["name": nameTextField.text!, "email": emailTextField.text!, "password": passwordTextField.text!, "mode":self.mode]
        
        
        Alamofire.upload(.POST, urlSring,headers: parame ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.ImageView.image!,0.4)! ,name: "file", fileName:"file.JPEG", mimeType: "singupImage/")
            
            
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
                            
                            let url = "https://nickgormanacademy.com/soccerSquat/singup/getIdUserSingup.php"
                            let parame:[String:String] = ["email":self.emailTextField.text!]
                            Alamofire.request(.GET,url, parameters: parame ,encoding: .URL).validate()
                                .responseJSON{(response) in
                                    var JSON = [AnyObject]()
                                    JSON = response.result.value as! [AnyObject]!
                                    for value in JSON {
                                        userId  = (value["uid"] as? String)!
                                        
                                    }
                                    print("Register Success")
                                    Activity().hideLoading()
                                    
                                    
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
        })
    }
    
    func customizeUI() {
        
        self.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        self.ImageView.contentMode = .ScaleAspectFill
        self.ImageView.layer.borderWidth = 1.0
        self.ImageView.layer.masksToBounds = false
        self.ImageView.layer.cornerRadius = self.ImageView.frame.height/2
        self.ImageView.clipsToBounds = true
        
        CustomPhotoButton.layer.borderColor = UIColor.whiteColor().CGColor
        CustomPhotoButton.layer.borderWidth = 1.0
        CustomPhotoButton.layer.cornerRadius = 11
        
        CustomRegisterButton.layer.cornerRadius = 16
        
        nameTextField.layer.cornerRadius = 17
        emailTextField.layer.cornerRadius = 17
        passwordTextField.layer.cornerRadius = 17
        confirmpasswordTextField.layer.cornerRadius = 17
        
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    //Function Checking Email
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFill
            ImageView.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFill
            ImageView.image = pickerImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newLength:Int = 0
        if textField == nameTextField {
            guard let text = nameTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 24
            
        }else if textField == emailTextField {
            guard let text = emailTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 30
            
        }else if textField == passwordTextField {
            guard let text = passwordTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 12
            
        }else if textField == confirmpasswordTextField {
            guard let text = confirmpasswordTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 12
            
        }else {
            print("Other TextField")
        }
        
        
        return newLength <= limitLength
    }
    
}
